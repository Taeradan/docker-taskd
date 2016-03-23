IMAGE=taeradan/taskd
CONTAINER=taskd
USERS_DIR=users

run: build
	docker run -d --name $(CONTAINER) -p 53589:53589 $(IMAGE)

stop:
	docker stop $(CONTAINER)

rm: stop
	docker rm $(CONTAINER)

build: Dockerfile taskd-config
	docker build -t $(IMAGE) .
	touch build

add_user:
	docker exec $(CONTAINER) taskd add user 'Default' '$(NEW_USER)'
	docker exec $(CONTAINER) ./generate.client $(NEW_USER)
	mkdir -p $(USERS_DIR)/$(NEW_USER)
	docker cp $(CONTAINER):/usr/share/taskd/pki/ca.cert.pem $(USERS_DIR)/$(NEW_USER)
	docker cp $(CONTAINER):/usr/share/taskd/pki/$(NEW_USER).cert.pem $(USERS_DIR)/$(NEW_USER)
	docker cp $(CONTAINER):/usr/share/taskd/pki/$(NEW_USER).key.pem $(USERS_DIR)/$(NEW_USER)
