ARG build_user
ARG build_tag
FROM ${build_user}/open5gs-base:${build_tag} AS base
FROM node:lts-alpine

COPY --from=base /open5gs/webui /usr/src/open5gs/webui

WORKDIR /usr/src/open5gs/webui
RUN npm clean-install && \
    npm run build

CMD npm run dev

EXPOSE 3000