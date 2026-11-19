FROM memcached:1.6.45-alpine@sha256:084fb554292d1447bc2c68b80c2331b98834514f56c866bc21a61be3c2ee376d

ENV SASL_CONF_PATH=/home/memcache/memcached.conf \
    MEMCACHED_SASL_PWDB=/home/memcache/memcached-sasl-db

COPY --chmod=0755 start.sh /usr/local/bin/railway-memcached-start.sh
ENTRYPOINT []
CMD ["/usr/local/bin/railway-memcached-start.sh"]
