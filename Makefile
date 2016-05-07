IMAGE=taeradan/taskd
CONTAINER=taskd
#CONTAINER=dockertaskd_taskd_1
USERS_DIR=users

run:
	docker-compose up -d

run_local: build
	make run

build: Dockerfile taskd-config
	docker build -t $(IMAGE) .
	touch build

stop:
	docker stop $(CONTAINER)

rm: stop
	docker rm $(CONTAINER)

add_user:
	docker-compose exec $(CONTAINER) taskd add user 'Default' '$(NEW_USER)'
	docker-compose exec $(CONTAINER) ./generate.client $(NEW_USER)
	mkdir -p $(USERS_DIR)/$(NEW_USER)
	docker cp $(CONTAINER):/usr/share/taskd/pki/ca.cert.pem $(USERS_DIR)/$(NEW_USER)
	docker cp $(CONTAINER):/usr/share/taskd/pki/$(NEW_USER).cert.pem $(USERS_DIR)/$(NEW_USER)
	docker cp $(CONTAINER):/usr/share/taskd/pki/$(NEW_USER).key.pem $(USERS_DIR)/$(NEW_USER)
