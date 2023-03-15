# include .env
# export $(shell sed 's/=.*//' .env)
export PYTHONPATH=$(CURDIR)

.PHONY: help
help: ## Command help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Reset project and clean containers
	@docker-compose down -v --remove-orphans | true
	@docker-compose rm -f | true

.PHONY: install
install: ## Install dependencies
	# @curl -sSL https://install.python-poetry.org | python3 -
	@poetry env use python3
	@poetry install

.PHONY: run
run: ## Run the api
	@poetry run uvicorn main:app --host 0.0.0.0 --port 9000 --reload

.PHONY: build
build: ## Run the api container image
	@docker build -t rbiondi/app:latest .

.PHONY: push
push: ## Push image to docker hub
	@docker push rbiondi/app:latest

.PHONY: test
test: ## Push image to docker hub
	@docker run --rm -p 9000:9000 rbiondi/api:latest

.PHONY: kube-deploy
kube-deploy: ## Deploy manifest to Kubernetes
	@kubectl apply -f cd/manifests/api-deployment.yaml
	@kubectl apply -f cd/manifests/api-service.yaml

.PHONY: kube-delete
kube-delete: ## Undeploy from Kubernetes
	@kubectl delete -f cd/manifests/api-deployment.yaml
	@kubectl delete -f cd/manifests/api-service.yaml

.PHONY: kube-port-forward
kube-port-forward: ## Kubernetes Port forward
	@kubectl port-forward service/api-service 9000:9000

.PHONY: kustomize
kustomize: ## Run the kustomize build
	@cd k8s; kustomize build
