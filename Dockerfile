# Build image
FROM golang:1.14-alpine as builder

ENV GO111MODULE=on

RUN apk add --no-cache git

COPY caddy.go /go/build/caddy.go
COPY go.mod /go/build/go.mod
COPY go.sum /go/build/go.sum

RUN cd /go/build && go get ./...
RUN cd /go/build && \
    go build -o /go/build/caddy .

# dist image
FROM alpine:3.10

# install deps
RUN apk add --no-cache --no-progress curl tini ca-certificates

# copy Caddy binary
COPY --from=builder /go/build/caddy /usr/bin/caddy

# list plugins
RUN /usr/bin/caddy -plugins

# static files volume
VOLUME ["/www"]
WORKDIR /www

#COPY Caddyfile /etc/caddy/Caddyfile
#COPY index.md /www/index.md

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["caddy", "--conf", "/etc/caddy/Caddyfile"]
