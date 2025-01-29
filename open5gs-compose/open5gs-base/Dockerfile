FROM alpine:latest

RUN apk update && \
    apk add --no-cache \
    alpine-sdk \
    bison \
    flex \
    git \
    cmake \
    meson \
    bash \
    linux-headers \
    bsd-compat-headers \
    yaml-dev \
    lksctp-tools-dev \
    gnutls-dev \
    libgcrypt-dev \
    libidn-dev \
    mongo-c-driver-dev \
    libmicrohttpd-dev \
    curl-dev \
    nghttp2-dev \
    talloc-dev \
    iproute2

ARG build_tag
RUN echo "#define REG_STARTEND (1 << 2)" >> /usr/include/regex.h && \
    git clone --depth 1 --branch ${build_tag} https://github.com/open5gs/open5gs /open5gs && \
    cd /open5gs
WORKDIR /open5gs
RUN meson build && \
    ninja -C build install

ARG build_nf_list
RUN for nf in ${build_nf_list}; \
    do mkdir -p lib-${nf} && ldd build/src/${nf}/open5gs-${nf}d | awk '{print $3}' | sed '/^$/d' | sed '/^\/lib\//d' | while read dep; do cp ${dep} lib-${nf}; done; done
