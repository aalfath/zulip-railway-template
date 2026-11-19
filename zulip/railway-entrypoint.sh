#!/bin/bash
# Install the first-boot organization script into Zulip's post-setup hook
# folder on the data volume (run after migrations), then hand over to the
# official entrypoint.
set -eu
DATA_DIR="${DATA_DIR:-/data}"
mkdir -p "$DATA_DIR/post-setup.d"
install -m 0755 /usr/local/lib/zulip-railway/create-organization.sh \
    "$DATA_DIR/post-setup.d/10-railway-create-organization"
exec /sbin/entrypoint.sh "$@"
