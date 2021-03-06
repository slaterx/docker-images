#!/bin/bash

set -x
set -m

/entrypoint.sh couchbase-server &

COUCHBASE_MASTER=$COUCHBASE_MASTER_SERVICE_HOST
COUCHBASE_MASTER_PORT=$COUCHBASE_MASTER_SERVICE_PORT

sleep 15

# Setup index and memory quota
curl -v -X POST http://127.0.0.1:8091/pools/default -d memoryQuota=300 -d indexMemoryQuota=300

# Setup services
curl -v http://127.0.0.1:8091/node/controller/setupServices -d services=kv%2Cn1ql%2Cindex

# Setup credentials
curl -v http://127.0.0.1:8091/settings/web -d port=8091 -d username=Administrator -d password=password

# Setup Memory Optimized Indexes
curl -i -u Administrator:password -X POST http://127.0.0.1:8091/settings/indexes -d 'storageMode=memory_optimized'

# Load travel-sample bucket
#curl -v -u Administrator:password -X POST http://127.0.0.1:8091/sampleBuckets/install -d '["travel-sample"]'

echo "Type: $TYPE"

if [ "$TYPE" = "WORKER" ]; then
  echo "Sleeping ..."
  sleep 15

  #IP=`hostname -s`
  IP=`hostname -I | cut -d ' ' -f1`
  echo "IP: " $IP

  echo "Auto Rebalance: $AUTO_REBALANCE"
  if [ "$AUTO_REBALANCE" = "true" ]; then
    couchbase-cli server-add -c $COUCHBASE_MASTER:$COUCHBASE_MASTER_PORT -u Administrator -p password --server-add=$IP --server-add-username=Administrator --server-add-password=password
    couchbase-cli rebalance -c $COUCHBASE_MASTER:$COUCHBASE_MASTER_PORT -u Administrator -p password
  else
    couchbase-cli server-add -c $COUCHBASE_MASTER:$COUCHBASE_MASTER_PORT -u Administrator -p password --server-add=$IP --server-add-username=Administrator --server-add-password=password
  fi;
fi;

fg 1
