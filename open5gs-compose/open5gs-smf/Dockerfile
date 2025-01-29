ARG build_user
ARG build_tag
FROM ${build_user}/open5gs-base:${build_tag} AS base
FROM alpine:latest

RUN mkdir -p /usr/local/etc/open5gs/tls && \
    mkdir -p /var/local/log/open5gs

COPY --from=base /usr/local/bin/open5gs-smfd /usr/local/bin/
COPY --from=base /usr/local/etc/open5gs/smf*.yaml /usr/local/etc/open5gs
COPY --from=base /usr/local/etc/open5gs/tls/smf* /usr/local/etc/open5gs/tls/
COPY --from=base /usr/local/etc/open5gs/tls/ca.crt /usr/local/etc/open5gs/tls/
COPY --from=base /open5gs/lib-smf/* /usr/local/lib/
COPY --from=base /usr/local/etc/freeDiameter/smf.conf /usr/local/etc/freeDiameter/
COPY --from=base /usr/local/lib/freeDiameter/* /usr/local/lib/freeDiameter/

VOLUME [ "/usr/local/etc/open5gs" ]
WORKDIR /usr/local/bin/
CMD open5gs-smfd
