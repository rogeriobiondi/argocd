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
 
.PHONY: kube-create
kube-create: ## Deploy manifest to Kubernetes
	@kubectl create namespace api
	@kubectl apply -f k8s/api-deployment.yaml --namespace api
	@kubectl apply -f k8s/api-service.yaml --namespace api

.PHONY: kube-delete
kube-delete: ## Undeploy from Kubernetes
	@kubectl delete -f k8s/api-deployment.yaml --namespace api
	@kubectl delete -f k8s/api-service.yaml --namespace api
	@kubectl delete namespace api

.PHONY: kube-port-forward
kube-port-forward: ## Kubernetes Port forward
	@kubectl port-forward service/api-service 9000:9000 --namespace api

.PHONY: kustomize
kustomize: ## Run the kustomize build
	@cd k8s; kustomize build

.PHONY: helm-create
helm-create: ## Run the helm install in debug mode
	@helm create helm

.PHONY: helm-dry-run
helm-dry-run: ## Run the helm install in debug mode
	@helm install helmapp helm --debug --dry-run

.PHONY: helm-install
helm-install: ## Deploy the application via helm
	@kubectl create namespace api
	@helm install helmapp helm

.PHONY: helm-uninstall
helm-uninstall: ## Undeploy the helm application
	@helm uninstall helmapp
	@kubectl delete namespace api