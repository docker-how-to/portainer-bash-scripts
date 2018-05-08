FROM alpine

ENV LANG="en_US.UTF-8" \
    LC_ALL="C.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TERM="xterm"

RUN apk --update add \
      curl \
      bash \
      ca-certificates \
      jq \
      vim \
      && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*

ADD ./stack-update.sh /stack-update.sh

RUN chmod u+x  /stack-update.sh

EXPOSE 80

ENV P_USER="root" \
    P_PASS="password" \
    P_URL="http://example.com:9000" \
    P_PRUNE="false"

ENTRYPOINT /stack-update.sh
