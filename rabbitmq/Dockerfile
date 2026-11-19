FROM rabbitmq:4.2.9@sha256:b9d197873347be3a527ce3bf1056b4d7ddc522417731cbd1489f3b05d51c4d35

# A fixed node name keeps the message store on the volume across redeploys
# (Railway gives each deployment a new hostname).
ENV RABBITMQ_NODENAME=rabbit@localhost \
    RABBITMQ_DEFAULT_USER=zulip

COPY start.sh /usr/local/bin/railway-rabbitmq-start.sh
RUN chmod 0755 /usr/local/bin/railway-rabbitmq-start.sh
CMD ["/usr/local/bin/railway-rabbitmq-start.sh"]
