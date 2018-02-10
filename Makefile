# By Andrew Paradi | Source at https://github.com/andrewparadi/docker-uwaterloo

TAG=gcc

default: pull

init:

build_file:
	bash -c "./build_dockerfile.sh"

build: build_file
	bash -c "docker build -t andrewparadi/uwaterloo:$(TAG) $(TAG)"
	bash -c "docker run -it -v $(shell pwd):/src --entrypoint /bin/bash -w /src andrewparadi/uwaterloo:$(TAG)"

rebuild: build_file
	bash -c "docker build -t andrewparadi/uwaterloo:$(TAG) --no-cache $(TAG)"
	bash -c "docker run -it -v $(shell pwd):/src --entrypoint /bin/bash -w /src andrewparadi/uwaterloo:$(TAG)"

run: init
	bash -c "docker run -it -v $(shell pwd):/src --entrypoint /bin/bash -w /src andrewparadi/uwaterloo:$(TAG)"

pull: init
	bash -c "docker pull andrewparadi/uwaterloo:$(TAG)"
	bash -c "docker run -it -v $(shell pwd):/src --entrypoint /bin/bash -w /src andrewparadi/uwaterloo:$(TAG)"

.PHONY: init
.PHONY: build
.PHONY: rebuild
.PHONY: run
