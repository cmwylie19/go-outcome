# Makefile for building the go app + docker image.
SHELL=bash
DOCKER_USERNAME=<YOUR_USERNAME>
IMAGE_REGISTRY=<YOUR_IMAGE_REGISTRY>
APP_NAME=<APP_NAME>
VERSION=0.0.1
ARCH=amd64


IMAGE ?= ${IMAGE_REGISTRY}/${DOCKER_USERNAME}/${APP_NAME}:${VERSION}

#---------------------------
# Build the secret-watcher binary

.PHONY: compile/app
compile/app:
	GOARCH=${ARCH} GOOS=linux go build -ldflags="-s -w" -o build/${APP_NAME} *.go


#---------------------------
# Build the docker image

.PHONY: build/image
build/image:
	docker build -t $(IMAGE) build/
	rm build/secret-watcher

#--------------------------------
# Push the docker image to dockerhub
.PHONY: push/image
push/image:
	docker push $(IMAGE)

#--------------------------------
all: compile/app build/image push/image
	@echo "Done building ${APP_NAME} for ${ARCH}"
