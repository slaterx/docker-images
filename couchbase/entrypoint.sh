#!/bin/bash
set -e

[[ "$1" == "couchbase-server" ]] && {
    echo "Starting Couchbase Server -- Web UI available at http://<ip>:8091 and logs available in /opt/couchbase/var/lib/couchbase/logs"
    exec /etc/service/couchbase-server/run
}

exec "$@"
