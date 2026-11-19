#!/bin/bash
# Runs after every boot's migrations (Zulip post-setup hook). On the first
# boot only, when no organization exists yet, it creates one with an owner
# account from ZULIP_ADMIN_EMAIL / ZULIP_ADMIN_PASSWORD. It never changes an
# existing organization or password.
set -eu
MANAGE=/home/zulip/deployments/current/manage.py

count="$(runuser -u zulip -- "$MANAGE" shell -c \
    "from zerver.models import Realm; print(Realm.objects.exclude(string_id='zulipinternal').count())" \
    2>/dev/null | tail -n 1)"

if [ "$count" != "0" ]; then
    echo "railway: an organization already exists; nothing to create."
    exit 0
fi

if [ -z "${ZULIP_ADMIN_EMAIL:-}" ] || [ -z "${ZULIP_ADMIN_PASSWORD:-}" ]; then
    echo "railway: ZULIP_ADMIN_EMAIL or ZULIP_ADMIN_PASSWORD is empty; not creating an organization."
    echo "railway: open this one-time link to create one:"
    runuser -u zulip -- "$MANAGE" generate_realm_creation_link
    exit 0
fi

# Write first, then hand to the zulip user (the kernel's protected_regular
# blocks root from opening another user's file in /tmp).
pwfile="$(mktemp)"
chmod 600 "$pwfile"
printf '%s' "$ZULIP_ADMIN_PASSWORD" > "$pwfile"
chown zulip "$pwfile"
echo "railway: creating organization '${ZULIP_ORG_NAME:-Zulip}' with owner ${ZULIP_ADMIN_EMAIL}"
if runuser -u zulip -- "$MANAGE" create_realm "${ZULIP_ORG_NAME:-Zulip}" \
    "$ZULIP_ADMIN_EMAIL" "${ZULIP_ADMIN_NAME:-Zulip Owner}" --password-file "$pwfile"; then
    echo "railway: organization created. Log in at https://${SETTING_EXTERNAL_HOST:-YOUR-DOMAIN}/ with ZULIP_ADMIN_EMAIL and ZULIP_ADMIN_PASSWORD."
else
    echo "railway: create_realm failed; see the error above."
fi
rm -f "$pwfile"
