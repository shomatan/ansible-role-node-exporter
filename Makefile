DOCKER_IMAGE_NAME=node-exporter-test-image
DOCKER_CONTAINER_NAME=node-exporter-test
PLAYBOOK_CMD=ansible-playbook node-exporter/tests/test.yml -i node-exporter/tests/inventory

.PHONY: build
build:
	docker build ./tests -t $(DOCKER_IMAGE_NAME)

.PHONY: run-container
run-container: build
	@if `docker ps -a | grep -q $(DOCKER_CONTAINER_NAME)`; then \
		make clean; \
	fi
	docker run -d -v ${PWD}:/test/node-exporter \
		--name $(DOCKER_CONTAINER_NAME) \
		--privileged \
		$(DOCKER_IMAGE_NAME) \
		/sbin/init

.PHONY: check
check: run-container
	docker exec -it $(DOCKER_CONTAINER_NAME) $(PLAYBOOK_CMD) --syntax-check

.PHONY: test
test: check
	docker exec -it $(DOCKER_CONTAINER_NAME) $(PLAYBOOK_CMD)
	@echo "\n*********** Test ***********"
	@docker exec -it $(DOCKER_CONTAINER_NAME) systemctl status node_exporter

.PHONY: clean
clean:
	-@docker rm -f $(DOCKER_CONTAINER_NAME)

.PHONY: destroy
destroy: clean
	-@docker rmi -f $(DOCKER_IMAGE_NAME)