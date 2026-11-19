# Zulip Server for Railway: the official image, unchanged, plus a small wrapper
# that creates the first organization and its owner on first boot.
FROM ghcr.io/zulip/zulip-server:13.2-0@sha256:c1a6e8ae68c19f92d4bbd5f0860455298c3669d7cba2baa9d4cf9a7ef9d8ccf4

# Fixed settings for Railway (the deployer never needs to change these).
# - Railway terminates TLS, so nginx serves plain HTTP on port 80.
# - Railway's proxies reach the container from the CGNAT range; trust their
#   X-Forwarded-For and let them call /health.
# - The container sees the host's RAM, not its own limit, so pin the worker
#   counts instead of letting Zulip size them for a huge machine.
# - Nightly pg_dump backups into the volume have no rotation; they're off by
#   default (set AUTO_BACKUP_ENABLED=True on the service to turn them on).
ENV PORT=80 \
    CERTIFICATES="" \
    LOADBALANCER_IPS="100.64.0.0/10" \
    AUTO_BACKUP_ENABLED=False \
    SETTING_REMOTE_POSTGRES_SSLMODE=disable \
    CONFIG_application_server__queue_workers_multiprocess=False \
    CONFIG_application_server__uwsgi_processes=4

COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
COPY create-organization.sh /usr/local/lib/zulip-railway/create-organization.sh
RUN chmod 0755 /usr/local/bin/railway-entrypoint.sh /usr/local/lib/zulip-railway/create-organization.sh \
    && bash -n /usr/local/bin/railway-entrypoint.sh \
    && bash -n /usr/local/lib/zulip-railway/create-organization.sh

ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
CMD ["app:run"]
