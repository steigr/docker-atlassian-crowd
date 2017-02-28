IMAGE    ?= steigr/atlassian-crowd
VERSION  ?= $(shell git branch | grep \* | cut -d ' ' -f2)
PORT     ?= 8095
BASE     ?= steigr/tomcat:latest

all: image
	@true

image:
	@sed 's#^FROM .*#FROM $(BASE)#' Dockerfile > Dockerfile.build
	[[ "$(NO_PULL)" ]] || docker pull $$(grep ^FROM Dockerfile.build | awk '{print $$2}')
	docker build --tag=$(IMAGE):$(VERSION) --file=Dockerfile.build .
	@rm Dockerfile.build

run: image
	docker run --rm --publish=$(PORT):$(PORT) --name=$(shell basename $(IMAGE)) --env=CATALINA_CONNECTOR_$(PORT)_upgrade=http2 $(IMAGE):$(VERSION)
