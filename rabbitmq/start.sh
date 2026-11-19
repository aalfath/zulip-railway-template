#!/bin/sh
# Same as upstream docker-zulip's compose: the user and password for the
# first boot come from the environment.
set -eu
: "${RABBITMQ_DEFAULT_PASS:?RABBITMQ_DEFAULT_PASS must be set}"
mkdir -p /etc/rabbitmq/conf.d
cat > /etc/rabbitmq/conf.d/90-railway.conf <<'CONF'
default_user = $(RABBITMQ_DEFAULT_USER)
default_pass = $(RABBITMQ_DEFAULT_PASS)
CONF
exec docker-entrypoint.sh rabbitmq-server
