PROJECT           = postgres
REGISTRY  	  = iamliamnorton
TAG              ?= latest

IMAGE = $(REGISTRY)/$(PROJECT):$(TAG)

.PHONY: build
build:
	docker build --rm -t $(IMAGE) .

.PHONY: test
test:
	docker run --rm -it \
	  $(IMAGE) \
	  postgres --version

.PHONY: shell
shell:
	docker run --rm -it \
	  --privileged \
	  $(IMAGE) \
	  bash

.PHONY: run
run:
	docker run --rm -it \
	  -p 5432:5432 \
	  -v /var/lib/postgresql/data:/data \
	  -e "PERSIST_DATA=true" \
	  $(IMAGE)

.PHONY: push
push:
	docker push $(IMAGE)
