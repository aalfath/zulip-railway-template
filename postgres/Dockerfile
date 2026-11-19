# Zulip's own PostgreSQL 14 image (PGroonga, hunspell dictionaries and Zulip's
# stop words for full-text search), as used by upstream docker-zulip.
FROM zulip/zulip-postgresql:14@sha256:e71ba8616fa42cdc1b248f51263d9290c29681cb8c1992eb9b498af0bb656b29

# Data goes in a subfolder of the Railway volume (the volume root holds lost+found).
ENV POSTGRES_USER=zulip \
    POSTGRES_DB=zulip \
    PGDATA=/var/lib/postgresql/data/pgdata
