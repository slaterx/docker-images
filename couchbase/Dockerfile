FROM couchbase/server:5.0.0-beta2

COPY run /etc/service/couchbase-server/run

COPY entrypoint.sh /

COPY configure-node.sh /opt/couchbase

RUN chgrp -R root /opt/couchbase && chmod 775 /opt/couchbase/configure-node.sh && chmod 775 /entrypoint.sh && chmod 775 /etc/service/couchbase-server/run

#HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:8091/pools || exit 1

CMD ["/opt/couchbase/configure-node.sh"]
