package main

import (
	"github.com/caddyserver/caddy/caddy/caddymain"

	_ "github.com/abiosoft/caddy-git"
	_ "github.com/dhaavi/caddy-permission"
	_ "github.com/lucaslorentz/caddy-docker-proxy/plugin"
	_ "github.com/tierklinik-dobersberg/caddy-matomo"
)

func main() {
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
