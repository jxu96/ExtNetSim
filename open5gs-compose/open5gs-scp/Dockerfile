ARG build_user
ARG build_tag
FROM ${build_user}/open5gs-base:${build_tag} AS base
FROM alpine:latest

RUN mkdir -p /usr/local/etc/open5gs/tls && \
    mkdir -p /var/local/log/open5gs

COPY --from=base /usr/local/bin/open5gs-scpd /usr/local/bin/
COPY --from=base /usr/local/etc/open5gs/scp*.yaml /usr/local/etc/open5gs
COPY --from=base /usr/local/etc/open5gs/tls/scp* /usr/local/etc/open5gs/tls/
COPY --from=base /usr/local/etc/open5gs/tls/ca.crt /usr/local/etc/open5gs/tls/
COPY --from=base /open5gs/lib-scp/* /usr/local/lib/

VOLUME [ "/usr/local/etc/open5gs" ]
WORKDIR /usr/local/bin/
CMD open5gs-scpd
