#!/usr/bin/env bash
set -euo pipefail

NS="${1:-rucio}"
LABEL_SELECTOR="${2:-app-group=rucio-daemons}"
CONTAINER="${3:-}"   # optional: pass container name if needed, e.g. rucio-daemons

exec_in_pod() {
  local pod="$1"
  shift
  if [[ -n "$CONTAINER" ]]; then
    kubectl -n "$NS" exec "$pod" -c "$CONTAINER" -- "$@"
  else
    kubectl -n "$NS" exec "$pod" -- "$@"
  fi
}

# Get all daemon types present
DAEMONS=$(
  kubectl -n "$NS" get pods -l "$LABEL_SELECTOR" \
    -o jsonpath='{range .items[*]}{.metadata.labels.rucio-daemon}{"\n"}{end}' \
  | sed '/^$/d' | sort -u
)

if [[ -z "${DAEMONS}" ]]; then
  echo "No pods found in namespace '$NS' with label selector '$LABEL_SELECTOR'."
  exit 1
fi

echo "Namespace: $NS"
echo "Label selector: $LABEL_SELECTOR"
[[ -n "$CONTAINER" ]] && echo "Container: $CONTAINER"
echo "Daemon types found: $(echo "$DAEMONS" | wc -l | tr -d ' ')"
echo

for D in $DAEMONS; do
  # List all pods for this daemon type
  PODS=$(
    kubectl -n "$NS" get pods -l "$LABEL_SELECTOR,rucio-daemon=$D" \
      -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' \
    | sort
  )

  echo "=== daemon: $D  (pods: $(echo "$PODS" | wc -l | tr -d ' ')) ==="

  for POD in $PODS; do
    echo "-- pod: $POD"

    # 1) Env var check
    if ! exec_in_pod "$POD" sh -lc 'env | grep -i "^RUCIO_CFG_DATABASE_POOLCLASS="'; then
      echo "RUCIO_CFG_DATABASE_POOLCLASS=<missing>"
    fi

    # 2) SQLAlchemy pool check
    if ! exec_in_pod "$POD" sh -lc "cd /tmp && python3 - <<'PY'
from rucio.db.sqla import session
e = session.get_engine()
print(type(e.pool).__name__)
PY"; then
      echo "PoolCheck=<failed>"
    fi

    echo
  done
done

