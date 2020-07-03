## Docker image naming; overridable by environment
IMAGE_NAME ?= ibmcloud-image-builder
IMAGE_VERSION_LATEST ?= latest
REMOTE_BRANCH ?= master

## Options
default: all

all: build run-tests cleanup

build:
	- echo '{"experimental": true}' | sudo tee /etc/docker/daemon.json; sudo service docker restart; docker version
	- docker build --squash . -f Dockerfile -t $(IMAGE_NAME):$(IMAGE_VERSION_LATEST)

mac_build:
	docker build --squash . -f Dockerfile -t $(IMAGE_NAME):$(IMAGE_VERSION_LATEST)

run-tests:
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/ubuntu/bionic/base  ; ./packer-build.sh"
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/ubuntu/bionic/docker; ./packer-build.sh"
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/centos/7/base       ; ./packer-build.sh"

cleanup:
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/ubuntu/bionic/base  ; ./packer-delete.sh"
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/ubuntu/bionic/docker; ./packer-delete.sh"
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/centos/7/base       ; ./packer-delete.sh"

ubuntu-bionic-base:
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/ubuntu/bionic/base  ; ./packer-build.sh"
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/ubuntu/bionic/base  ; ./packer-delete.sh"

ubuntu-bionic-docker:
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/ubuntu/bionic/docker; ./packer-build.sh"
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/ubuntu/bionic/docker; ./packer-delete.sh"

centos-7-base:
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/centos/7/base       ; ./packer-build.sh"
	docker run --privileged -v `pwd`:/ibmcloud-image-builder ${IMAGE_NAME}:${IMAGE_VERSION_LATEST} /bin/bash -c "cd packer/centos/7/base       ; ./packer-delete.sh"

.PHONY: all
