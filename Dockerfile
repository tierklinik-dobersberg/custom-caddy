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
FROM alpinelinux/docker-cli:latest

# install deps
RUN apk add --no-cache --no-progress curl tini ca-certificates

# copy Caddy binary
COPY --from=builder /go/build/caddy /usr/bin/caddy

# list plugins
RUN /usr/bin/caddy -plugins

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile
COPY index.html /srv/index.html

ENTRYPOINT ["/sbin/tini", "--", "caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE"]
