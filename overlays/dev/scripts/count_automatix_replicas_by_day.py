#!/usr/bin/env python3
from __future__ import annotations

import argparse
from collections import defaultdict
from typing import Dict, Iterable, List, Optional

from rucio.client.didclient import DIDClient
from rucio.client.replicaclient import ReplicaClient


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="Count Automatix FILE replicas per RSE for a given day (YYYY-MM-DD)."
    )
    p.add_argument("--scope", default="user.automatix", help="Scope (default: user.automatix)")
    p.add_argument("--did-prefix", default="automatix", help="DID prefix (default: automatix)")
    p.add_argument("--day", required=True, help="Day in YYYY-MM-DD, e.g. 2026-02-10")
    p.add_argument(
        "--schemes",
        default="",
        help="Optional comma-separated schemes to count PFNs for (e.g. 'davs,https'). "
             "If omitted, counts whatever protocols Rucio returns.",
    )
    p.add_argument(
        "--limit",
        type=int,
        default=0,
        help="Optional limit on number of files to scan (0 = no limit).",
    )
    return p.parse_args()


def iter_files_for_day(didc: DIDClient, scope: str, did_prefix: str, day: str) -> Iterable[Dict[str, str]]:
    """
    Yield {'scope': scope, 'name': filename} for FILE DIDs under:
      <did_prefix>/<day>/...
    """
    # Automatix naming: did_prefix/date/uuid[/fileuuid]
    # We want all FILE names starting with did_prefix/day/
    like_pat = f"{did_prefix}/{day}/%"

    # Rucio servers commonly accept SQL-LIKE wildcard in 'name' filter.
    # If your deployment uses a different key (e.g. 'name' vs 'name_like'),
    # tell me and I'll adjust.
    filters = {"name": like_pat, "type": "FILE"}

    for name in didc.list_dids(scope=scope, filters=filters, did_type="file"):
        yield {"scope": scope, "name": name}


def main() -> int:
    args = parse_args()
    didc = DIDClient()
    repc = ReplicaClient()

    schemes: Optional[List[str]] = None
    if args.schemes.strip():
        schemes = [s.strip() for s in args.schemes.split(",") if s.strip()]

    files_on_rse = defaultdict(int)      # RSE -> distinct files that have a replica there
    pfn_endpoints = defaultdict(int)     # RSE -> number of PFNs counted (may be > files)
    scanned = 0

    for did in iter_files_for_day(didc, args.scope, args.did_prefix, args.day):
        scanned += 1
        if args.limit and scanned > args.limit:
            break

        # list_replicas returns one entry per DID with rses->pfns mapping
        it = repc.list_replicas(
            dids=[did],
            schemes=schemes,
            all_states=True,
            ignore_availability=True,
            metalink=False,
        )
        try:
            entry = next(it)
        except StopIteration:
            continue

        rses_map = entry.get("rses") or {}
        for rse, pfns in rses_map.items():
            files_on_rse[rse] += 1
            # pfns may be list or dict depending on rucio version/config
            if isinstance(pfns, list):
                pfn_endpoints[rse] += len(pfns)
            elif isinstance(pfns, dict):
                pfn_endpoints[rse] += len(pfns)
            else:
                pfn_endpoints[rse] += 1

    print(f"Scope: {args.scope}")
    print(f"Day:   {args.day}")
    print(f"Scanned FILE DIDs: {scanned}")
    if schemes:
        print(f"Schemes counted: {', '.join(schemes)}")
    else:
        print("Schemes counted: (default / all returned)")
    print("")
    print(f"{'RSE':40} {'files_on_rse':>12} {'pfn_endpoints':>14}")
    print("-" * 70)

    for rse in sorted(files_on_rse.keys(), key=lambda k: (-files_on_rse[k], k)):
        print(f"{rse:40} {files_on_rse[rse]:12d} {pfn_endpoints[rse]:14d}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

