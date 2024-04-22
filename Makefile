api_path=zine.api
proxy_path=zine.proxy
web_path=zine.web

proxy_network=reverse-proxy

env=local


.PHONY: up up-api up-proxy up-web

up: up-api up-proxy up-web

up-api:
	@docker compose -f $(api_path)/compose.$(env).yaml up -d

up-proxy:
	@docker compose -f $(proxy_path)/compose.$(env).yaml up -d

up-web:
	@docker compose -f $(web_path)/compose.$(env).yaml up -d


.PHONY: down down-api down-proxy down-web

down: down-api down-web down-proxy

down-api:
	@docker compose -f $(api_path)/compose.$(env).yaml down

down-proxy:
	@docker compose -f $(proxy_path)/compose.$(env).yaml down

down-web:
	@docker compose -f $(web_path)/compose.$(env).yaml down


.PHONY: install git-pull-submodules network-create

install:
	@git submodule init
	@git submodule update
	@$(MAKE) network-create
	@git submodule foreach "git reset --hard origin/master && git pull origin master && make install"
	@$(MAKE) up

git-pull-submodules:
	@git submodule foreach "git reset --hard origin/master && git pull origin master"

network-create:
	@docker network create --driver bridge $(proxy_network) || true
