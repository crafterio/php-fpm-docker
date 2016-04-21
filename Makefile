DOCKER_REPO = crafterio/php-fpm-docker
VERSION ?= $(shell ls -r1 | grep -E '^[0-9]' | head -1)


.PHONY: build clean run

build:
	-docker images | grep $(DOCKER_REPO) | grep $(VERSION) > /dev/null 2>&1 && docker rmi -f $(DOCKER_REPO):$(VERSION)
	docker build --no-cache --force-rm -t $(DOCKER_REPO):$(VERSION) $(VERSION)

clean:
	docker rmi $(DOCKER_REPO):$(VERSION)

enter:
	docker run -P -ti $(DOCKER_REPO):$(VERSION) /bin/sh
