DOCKER_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
DOCKER = docker

# XXX: Set UID/GID in compose file to avoid root/user permission issues
export DOCKER_UID ?= $(shell id -u)
export DOCKER_GID ?= $(shell id -g)

DOCKER_COMPOSE = DOCKER_UID=$(DOCKER_UID) DOCKER_GID=$(DOCKER_GID) $(DOCKER) \
				 compose -f $(DOCKER_DIR)/docker-compose.yml

SRC_DIR = /opencca
FLASH_DIR = $(SRC_DIR)/flash/
SHELL_HISTORY = $(DOCKER_DIR)/.bash_history $(DOCKER_DIR)/.fish_history
SHELL := /bin/bash

VERSION_PULL = latest
VERSION_PUSH = latest

# XXX: These names must match in the compose file
SERVICE_URL = ghcr.io/opencca/opencca-flash
SERVICE = opencca-flash

export BUILD_DATE ?= $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
export BUILD_REF ?= $(shell git rev-parse HEAD)
export BUILD_VERSION ?= $(shell git rev-parse --short HEAD)

CACHE ?= 0

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

.PHONY: pull
pull: setup
	$(DOCKER) pull $(SERVICE_URL):$(VERSION_PULL)

.PHONY: build
build: setup
ifeq ($(CACHE),0)
	-@$(DOCKER) image rm $(SERVICE_URL):latest &> /dev/null || true # XXX: Remove explicitly
	-@$(DOCKER) image rm $(SERVICE_URL):$(VERSION_PUSH) &> /dev/null || true
	-@$(DOCKER) image rm $(SERVICE_URL):$(BUILD_VERSION) &> /dev/null || true
else
	@echo "Caching enabled. skipping building from scratch"
endif
	touch $(SHELL_HISTORY)

	$(DOCKER) buildx build \
		--file $(DOCKER_DIR)/Dockerfile \
		--tag $(SERVICE_URL):$(VERSION_PUSH) \
		--tag $(SERVICE_URL):$(BUILD_VERSION) \
		--build-arg BUILD_DATE="$(BUILD_DATE)" \
		--build-arg BUILD_REF="$(BUILD_REF)" \
		--build-arg BUILD_VERSION="$(BUILD_VERSION)" \
		--load  \
		$(DOCKER_DIR)/

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


# XXX: IN_CONTAINER set in dockerfile
.PHONY: flash
flash:	
	@if [ "$$IN_CONTAINER" = "1" ]; then \
		$(FLASH_DIR)/flash.sh $(filter-out $@,$(MAKECMDGOALS)); \
	else \
		$(DOCKER_COMPOSE) run --rm $(SERVICE) $(FLASH_DIR)/flash.sh $(filter-out $@,$(MAKECMDGOALS)); \
	fi

.PHONY: clean
clean: SYSTEM=0
clean:
	$(DOCKER) rm -f $(SERVICE) $(SERVICE_URL) &> /dev/null ||  true
	$(DOCKER) volume rm $$(docker volume ls -qf dangling=true) &> /dev/null || true
	[[ $(SYSTEM) == 1 ]] && $(DOCKER) system prune -f || true

.PHONY: release
# XXX: For use in CI server
release:
	@echo "Using SERVICE_URL: $(SERVICE_URL)"
	@echo "Using BUILD_VERSION: $(BUILD_VERSION)"

	$(DOCKER) push $(SERVICE_URL):$(BUILD_VERSION)
	$(DOCKER) push $(SERVICE_URL):$(VERSION_PUSH)	

# Allow make to handle non-declared arguments
%:
	@:
