FORCE_REBUILD ?= 0
JITSI_RELEASE ?= "stable"
JITSI_BUILD ?= "latest"

ifeq ($(FORCE_REBUILD), 1)
  BUILD_ARGS = "--no-cache"
endif

build-all:
	BUILD_ARGS=$(BUILD_ARGS) JITSI_RELEASE=$(JITSI_RELEASE) $(MAKE) -C base build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C base-java build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C web build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C prosody build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C jicofo build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C jvb build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C jigasi build

tag-all:
	docker tag jitsi/base:latest hajowieland/jitsi-base:$(JITSI_BUILD)
	docker tag jitsi/base-java:latest hajowieland/jitsi-base-java:$(JITSI_BUILD)
	docker tag jitsi/web:latest hajowieland/jitsi-web:$(JITSI_BUILD)
	docker tag jitsi/prosody:latest hajowieland/jitsi-prosody:$(JITSI_BUILD)
	docker tag jitsi/jicofo:latest hajowieland/jitsi-jicofo:$(JITSI_BUILD)
	docker tag jitsi/jvb:latest hajowieland/jitsi-jvb:$(JITSI_BUILD)
	docker tag jitsi/jigasi:latest hajowieland/jitsi-jigasi:$(JITSI_BUILD)

push-all:
	docker push hajowieland/jitsi-base
	docker push hajowieland/jitsi-base-java
	docker push hajowieland/jitsi-web
	docker push hajowieland/jitsi-prosody
	docker push hajowieland/jitsi-jicofo
	docker push hajowieland/jitsi-jvb
	docker push hajowieland/jitsi-jigasi

clean:
	docker-compose stop
	docker-compose rm
	docker network prune

.PHONY: build-all tag-all push-all clean
