FROM alpine:3 as downloader

ARG PORT
ENV PORT=$PORT

RUN wget https://github.com/pocketbase/pocketbase/releases/download/v0.16.7/pocketbase_0.16.7_linux_arm64.zip \
    && unzip pocketbase_0.16.7_linux_arm64.zip \
    && chmod +x /pocketbase

FROM alpine:3
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

EXPOSE $PORT

COPY --from=downloader /pocketbase /usr/local/bin/pocketbase
ENTRYPOINT ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:$PORT", "--dir=/pb_data", "--publicDir=/pb_public"]
