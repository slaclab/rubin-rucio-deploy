#!/bin/bash

FTS_SERVERS=https://lcgfts3.gridpp.rl.ac.uk:8446

### ADD USERS ###
# Brandon White
rucio-admin -a root account add bjwhite
rucio-admin -a root identity add --account bjwhite --type X509 --email 'bjwhite@fnal.gov' --id '/DC=org/DC=cilogon/C=US/O=Fermi National Accelerator Laboratory/OU=People/CN=Brandon White/CN=UID:bjwhite'
rucio-admin -a root account add-attribute --key admin --value True bjwhite

# Yuyi Guo
rucio-admin -a root account add yuyi 
rucio-admin -a root identity add --account yuyi --type X509 --email 'yuyi@fnal.gov' --id '/DC=org/DC=cilogon/C=US/O=Fermi National Accelerator Laboratory/OU=People/CN=Yuyi Guo/CN=UID:yuyi'
rucio-admin -a root account add-attribute --key admin --value True yuyi

# Omari Paul
rucio-admin -a root account add opaul
rucio-admin -a root identity add --account opaul --type X509 --email 'opaul@fnal.gov' --id '/DC=org/DC=cilogon/C=US/O=Fermi National Accelerator Laboratory/OU=People/CN=Omari Paul/CN=UID:opaul'
rucio-admin -a root account add-attribute --key admin --value True opaul

# Greg Daues
rucio-admin -a root account add daues
rucio-admin -a root identity add --account daues --type X509 --email 'daues@illinois.edu' --id '/DC=org/DC=cilogon/C=US/O=Fermi National Accelerator Laboratory/OU=People/CN=Gregory Daues/CN=UID:daues'
rucio-admin -a root account add-attribute --key admin --value True daues

# Fabio Hernandez
user=fabioh
rucio-admin -a root account add ${user}
rucio-admin -a root identity add --account ${user} --type X509 --email 'fabio@in2p3.fr' --id '/O=GRID-FR/C=FR/O=CNRS/OU=CC-IN2P3/CN=Fabio Hernandez'
rucio-admin -a root account add-attribute --key admin --value True ${user}

# Andy Hanushevsky
rucio-admin -a root account add abh
rucio-admin -a root identity add --account abh --type SSH --email 'abh.slac.stanford.edu' --id 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwjVM9PV53oEOwnlQhmR5GuTIUAagF9vaEd6gJVfyNdTRh58acAk37UhRz1CfURVtyHlwoCVCUrX37QsifsUufredCs8g9PIIidLaVQagoFaj0+tgRQlfHU/aDEDbyOciKg4TLBQuOZX3ZcrEHamkKnEgamQBzt1MnU3CmdWQVDlC8N+/alN7mUivbRabLQ+m93WA48YoLJOPbF6mQ5uWd0nce6sv+/aWQsihH+zzoJaZUz4fs82CHbMuLsPZLu1N50UlSy/rudGJetX0MCGsSq4nnnGxRghB67r6a+NuwC1U3LrLXL6EQY5ux7EVsKz4rYj23m5UhSkXYasfLiTwbw== abh@io'
rucio-admin -a root account add-attribute --key admin --value True abh

# Wei Yang
rucio-admin -a root account add yangw
rucio-admin -a root identity add --account yangw --type SSH --email 'yangw@slac.stanford.edu' --id 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDxdxD5mj4tciwdI5iRl6SW3L0BGHNNlX4G/JkUZ1/j3zWM9aTQ1U8/V9uaEFyzWCcak4PLzWKmz6QdQEC+X2tYtOuRdCcmx2lyBniAlunBdKXRetnUaQBRuuV0cYMR2V6qbPuBk816IsS1DwyDYZCe0C28/B3eJNjql6esm5jrqLBIwEdcf7O3kJ8SN9/XbHOoKWwGJHk0XHZlsGz3ID6XwY9Lvuu/bm5nY1Da+C/rrn2TosDcTKGlXJue4lJo3eX4xo/W/rWeGVGu3PVPYB6WQ+HGehaymvBeAHZMbfrJg/eadVbfSovkZ9La5/ZOplMV4gRi+HSP42q4Ns83GwkQWXP4Eo8Rw5LwZb2xrHC65htDSQH4dDNQI8GX63sF9QlXG7s59rRp8ZxmCGKDtWTuYDuAuQk7hV0nddIISTva0jdysNwcJz9D69AHFlfLfBQGTyayUxr4m05XoGx5Blm1dQE1B13EvAmMJHGvjtNrDQ+hpYmLBVDwJwsKZOo3/oOKiqU6SXYUaqo+5BysnCBwn++GBTrYFmX+AluMS1onWhuuI4d9DC+lHvvtdUzBVaO4MecU1tiWC1qQaBzltPkrA203IJsB6XIaPctcj/OgmlNvLVqX0HTVwsubbTxedyNUtlkYxHvaagui8jQOmjQPSmJFpHL3wb5VLP8ZCbFRxw== yangw@dhcp-swlan-public-81-142.slac.stanford.edu'
rucio-admin -a root account add-attribute --key admin --value True yangw

# Data Service
rucio-admin -a root account add register_service
rucio-admin -a root identity add --account register_service --type SSH --email 'ktl@slac.stanford.edu' --id 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdrexNG31GpEoRjrgvO8B2I7OzYUwuMPe3Zb28jO8rR1ZczHcVeYKGIIKTMMCX27wZk42+HLs/THaO7xGVEKKYjE/oSwuju/hzL2B2jVN97BvnIFTonDk4XUIzcZS+9cV85g9Ty+zEICvAa/N+gFhtgnNSPC/XlM0oobf1FjwRjf39y5zuRkRoRoHmU7pf6+HZYK9gAkQGMa1hGMyKDfqY685ieKxLNgccTbH5lriVDE/Hd96qLcVXXgfGNq5hSMGzVqLcx1rvkTI4jrkS354MkJFMvDBhtam1eot2bwoLbrGBJN/Uod7eEZoDzsPItxfHHJt7dpMw+NdjbtwDvG1bqwOGX/byYD02QGQXG7v/MuIix0N0igitLbEJh3iSggCqw2HN+i2AS/dLBukjRwkCrWUnm5qEZVBNBOOOtF9CxJM5nCofWTovNJanaKyB5x4BZnzfOGbFTVgLkbkZ0aRofX/y5lXsnBTZjXY0NPJRlom/M3Y3/ZiG0jI1njeQ3Wk= registersvc@usdf'
rucio-admin -a root account add-attribute --key admin --value True register_service

# Automatix
user=automatix
rucio-admin -a root account add ${user}
rucio-admin -a root identity add --account ${user} --type X509 --email 'bjwhite@fnal.gov' --id '/DC=org/DC=incommon/C=US/ST=California/O=Stanford University/CN=rubin-rucio-dev.slac.stanford.edu'
rucio-admin -a root account add-attribute --key admin --value True ${user}

### ADD RSES ####
rse=SLAC_TEST_DISK
rucio-admin -a root rse add ${rse}
rucio-admin -a root rse set-attribute --rse ${rse} --key fts --value ${FTS_SERVERS}
rucio-admin -a root rse set-attribute --rse ${rse} --key greedyDeletion --value True
rucio-admin -a root rse add-protocol --scheme root --hostname sdfdtn005.slac.stanford.edu --port 1094 --prefix '//lsst/testdisk/rucio' --domain-json '{"lan": {"read": 1, "write": 1, "delete": 1}, "wan": {"read": 2, "write": 2, "delete": 2, "third_party_copy_read": 2, "third_party_copy_write": 2}}' ${rse}
rucio-admin -a root rse add-protocol --scheme davs --hostname sdfdtn005.slac.stanford.edu --port 1094 --prefix '/lsst/testdisk/rucio' --domain-json '{"lan": {"read": 1, "write": 1, "delete": 1}, "wan": {"read": 2, "write": 2, "delete": 2, "third_party_copy_read": 2, "third_party_copy_write": 2}}' ${rse}

rse=RAL_TEST_DISK
rucio-admin -a root rse add ${rse}
rucio-admin -a root rse set-attribute --rse ${rse} --key fts --value ${FTS_SERVERS}
rucio-admin -a root rse set-attribute --rse ${rse} --key greedyDeletion --value True
rucio-admin -a root rse add-protocol --scheme root --hostname xrootd.echo.stfc.ac.uk --port 1094 --prefix '/lsst:testdisk' --domain-json '{"lan": {"read": 2, "write": 2, "delete": 2}, "wan": {"read": 2, "write": 2, "delete": 2, "third_party_copy_read": 2, "third_party_copy_write": 2}}' ${rse}
rucio-admin -a root rse add-protocol --scheme davs --hostname xrootd.echo.stfc.ac.uk --port 1094 --prefix '/lsst:testdisk' --domain-json '{"lan": {"read": 1, "write": 1, "delete": 1}, "wan": {"read": 1, "write": 1, "delete": 1, "third_party_copy_read": 1, "third_party_copy_write": 1}}' ${rse}

rse=IN2P3_TEST_DISK
rucio-admin -a root rse add ${rse}
rucio-admin -a root rse set-attribute --rse ${rse} --key fts --value ${FTS_SERVERS}
rucio-admin -a root rse set-attribute --rse ${rse} --key greedyDeletion --value True
rucio-admin -a root rse add-protocol --scheme davs --hostname ccdavrubin.in2p3.fr --port 2880 --prefix '/pnfs/in2p3.fr/lsst/rucio/test' --domain-json '{"lan": {"read": 1, "write": 1, "delete": 1}, "wan": {"read": 2, "write": 2, "delete": 2, "third_party_copy_read": 2, "third_party_copy_write": 2}}' ${rse}

### ADD DISTANCES ###
rucio-admin -a root rse add-distance --distance 3 SLAC_TEST_DISK RAL_TEST_DISK
rucio-admin -a root rse add-distance --distance 3 SLAC_TEST_DISK IN2P3_TEST_DISK 

rucio-admin -a root rse add-distance --distance 3 RAL_TEST_DISK SLAC_TEST_DISK
rucio-admin -a root rse add-distance --distance 2 RAL_TEST_DISK IN2P3_TEST_DISK

rucio-admin -a root rse add-distance --distance 3 IN2P3_TEST_DISK SLAC_TEST_DISK
rucio-admin -a root rse add-distance --distance 2 IN2P3_TEST_DISK RAL_TEST_DISK

### ADD Automatix Subscription ###
rucio-admin -a root scope add --scope user.automatix --account automatix
