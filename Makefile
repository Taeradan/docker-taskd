IMAGE=taeradan/taskd
CONTAINER=taskd

run: build
	docker run -d --name $(CONTAINER) -p 53589:53589 $(IMAGE)

stop:
	docker stop $(CONTAINER)

rm: stop
	docker rm $(CONTAINER)

build: Dockerfile taskd-config
	docker build -t $(IMAGE) .
	touch build
