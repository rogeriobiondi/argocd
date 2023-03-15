# argocd
ArgoCD continuous deployment sample

# Pre reqs

- Docker

## Use a remote or local Kubernetes installation

TODO

## Install kubectl

TODO

## Install Kustomize

```
sudo snap install kustomize
```

## Install Helm

TODO


# Steps

## Test Locally

```
make run
```

go to the addresses to check if the image is working:

http://localhost:9000/
http://localhost:9000/items/1
http://localhost:9000/healthz
http://localhost:9000/docs



## Build Container Image

```
make build
```

## Push Image to Docker Hub

```
make push
```

## Test image locally (using docker)

```
make test
```

go to the addresses to check if the image is working:

http://localhost:9000/
http://localhost:9000/items/1
http://localhost:9000/healthz
http://localhost:9000/docs


## Test direct deployment to Kubernetes (Manifests)

Deploy to kubernetes:

```
make kube-deploy
```

Port Forward to local TCP 9000:


```
make kube-port-forward
```

go to the addresses to check if the image is working:

http://localhost:9000/
http://localhost:9000/docs


## Clearance

Undeploy app from Kubernetes

```
make kube-delete
```



