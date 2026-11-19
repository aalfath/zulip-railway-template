#!/bin/sh
# Same as upstream docker-zulip's compose: SASL login "zulip" with the
# password from MEMCACHED_PASSWORD.
set -eu
: "${MEMCACHED_PASSWORD:?MEMCACHED_PASSWORD must be set}"
echo 'mech_list: plain' > "$SASL_CONF_PATH"
echo "zulip@${HOSTNAME:-memcached}:${MEMCACHED_PASSWORD}" > "$MEMCACHED_SASL_PWDB"
echo "zulip@localhost:${MEMCACHED_PASSWORD}" >> "$MEMCACHED_SASL_PWDB"
exec memcached -S -m "${MEMCACHED_MEMORY_MB:-256}"
