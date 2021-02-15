APP_CONTAINER  = sylius_php
EXEC_PHP_FPM   = docker exec $(APP_CONTAINER) sh -c

# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

## ----- Docker ------

build: ## Build containers
	docker-compose build

build-nc: ## Build containers without caching
	docker-compose build --no-cache

up: ## Start containers
	docker-compose up -d

down: ## Stop containers
	docker-compose down

sh: ## Shell on php container
	docker exec -it $(APP_CONTAINER) sh

## ----- Composer -----

install: composer.lock ## Install vendors according to the current composer.lock file
	$(EXEC_PHP_FPM) 'composer install'

update: composer.json ## Update vendors according to the current composer.json file
	$(EXEC_PHP_FPM) 'composer update'

test: ## Launch unit test for project
	$(EXEC_PHP_FPM) 'composer test'

## ----- Symfony ------

cache: ## Clear cache
	$(EXEC_PHP_FPM) 'bin/console cache:clear'

assets: ## Install symfony & sylius assets
	$(EXEC_PHP_FPM) 'bin/console assets:install'
	$(EXEC_PHP_FPM) 'bin/console sylius:theme:assets:install public'

run: ## Run a Symfony command
	$(EXEC_PHP_FPM) "bin/console $(filter-out $@,$(MAKECMDGOALS))"

## ----- Divers ------

purge: ## Purge cache and logs
	rm -rf var/cache/* var/logs/*
