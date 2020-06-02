package main

import (
	"github.com/caddyserver/caddy/caddy/caddymain"

	_ "github.com/dhaavi/caddy-permission"
  _ "github.com/abiosoft/caddy-git"
	_ "github.com/lucaslorentz/caddy-docker-proxy/plugin"
)

func main() {
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
