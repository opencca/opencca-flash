# we use same makefile in root and ./docker
DOCKER_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

DOCKER_COMPOSE = docker compose -f $(DOCKER_DIR)/docker-compose.yml
SERVICE = opencca-flash
SRC_DIR = /opencca
SHELL_HISTORY = $(DOCKER_DIR)/.bash_history $(DOCKER_DIR)/.fish_history
SHELL := /bin/bash

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  build         - Build the Docker image"
	@echo "  start         - Start the interactive development container"
	@echo "  enter         - Enter the running container"
	@echo "  run CMD='...' - Run a command inside the container"
	@echo "  stop          - Stop the container"
	@echo "  clean         - Remove the container and unused images"
	@echo "  flash  <args> - Run flash.sh in container"

.PHONY: build
build:
	touch $(SHELL_HISTORY)
	$(DOCKER_COMPOSE) build

.PHONY: start
start:
	$(DOCKER_COMPOSE) up -d

.PHONY: enter
enter:
	$(DOCKER_COMPOSE) exec $(SERVICE) bash

.PHONY: run
run:
	$(DOCKER_COMPOSE) run --rm $(SERVICE) $(CMD)

.PHONY: stop
stop:
	$(DOCKER_COMPOSE) stop

.PHONY: clean
clean:
	docker rm -f $(SERVICE) || true
	docker volume rm $$(docker volume ls -qf dangling=true) || true

# XXX: IN_CONTAINER set in dockerfile
.PHONY: flash
flash:	
	@if [ "$$IN_CONTAINER" = "1" ]; then \
		flash.sh $(filter-out $@,$(MAKECMDGOALS)); \
	else \
		$(DOCKER_COMPOSE) run --rm $(SERVICE) flash.sh $(filter-out $@,$(MAKECMDGOALS)); \
	fi

# Allow make to handle non-declared arguments
%:
	@: