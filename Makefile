PROJECT           = postgres
TAG              ?= dev

IMAGE = $(PROJECT):$(TAG)

.PHONY: build
build:
	docker build --rm -t $(IMAGE) .

.PHONY: test
test:
	docker run --rm -t $(IMAGE) true

.PHONY: shell
shell:
	docker run --rm -it --privileged $(IMAGE) bash

.PHONY: run
run:
	docker run --rm -it \
	  --name $(PROJECT)_$(TAG) \
	  -p 5432:5432 \
	  -v /var/lib/postgresql/data:/data \
	  -e "PERSIST_DATA=true" \
	  --privileged \
	  $(IMAGE) \
	  postgres
