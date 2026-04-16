# syntax=docker/dockerfile:1

FROM alpine/mongosh

COPY scripts/*.sh /app/

RUN chmod +x /app/*.sh \
  && apk add --no-cache bash supercronic tzdata \
  && ln -sf /tmp/timezone /etc/timezone

ENTRYPOINT ["/app/entrypoint.sh"]