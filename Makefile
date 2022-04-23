#!/bin/bash

DOCKER_BE = docker-symfony-be
UID = $(shell id -u)

help: ## show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

run: ## Start containers
	docker network create docker-symfony-network || true
	U_ID=${UID} docker-compose up -d

stop: ## Stop the containers
	U_ID=${UID} docker-compose stop

down: ## Stop the containers
	U_ID=${UID} docker-compose down

restart: ## Restart the container
	$(MAKE) stop && $(MAKE) run

build: ## Rebuilds all the containers
	U_ID=${UID} docker-compose build

prepare: ## Runs backend commands
	$(MAKE) composer-install

composer-install: ## Install all dependencies of compreser in proyect
	U_ID=${UID} docker exec --user ${UID} -it ${DOCKER_BE} composer install --no-scripts --no-interacion --optimize-autoloader

be-logs: ## Tails the symfony dev log
	U_ID=${UID} docker exec -it --user ${UID}  ${DOCKER_BE} tail -f var/log/dev.log
# End backend commands

ssh-be: ## ssh's into the be container
	U_ID=${UID} docker exec -it --user ${UID}  ${DOCKER_BE} bash

#code-style: ## Runs php-cs to fix code styling following Symfony Rules U_ID=${UID} docker exec -it --user ${UID}  ${DOCKER_BE} php-cs-fixer src --rules=@Symfony