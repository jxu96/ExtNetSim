ARG build_user
ARG build_tag
FROM ${build_user}/open5gs-base:${build_tag} AS base
FROM alpine:latest

RUN mkdir -p /usr/local/etc/open5gs/tls && \
    mkdir -p /var/local/log/open5gs && \
    apk add --no-cache iproute2 iptables iperf3

COPY --from=base /usr/local/bin/open5gs-upfd /usr/local/bin/
COPY --from=base /usr/local/etc/open5gs/upf*.yaml /usr/local/etc/open5gs
COPY --from=base /usr/local/etc/open5gs/tls/upf* /usr/local/etc/open5gs/tls/
COPY --from=base /usr/local/etc/open5gs/tls/ca.crt /usr/local/etc/open5gs/tls/
COPY --from=base /open5gs/lib-upf/* /usr/local/lib/
COPY ./setup_tun.sh /usr/local/bin/

VOLUME [ "/usr/local/etc/open5gs" ]
WORKDIR /usr/local/bin/
CMD sh ./setup_tun.sh && open5gs-upfd
