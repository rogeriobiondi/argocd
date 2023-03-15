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


## Install ArgoCD

```
# Create namespace
kubectl create namespace argocd
# Apply manifest - wait a few seconds until complete
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Get the admin user credentials:

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Port forward:

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Access the ArgoCD Console:

http://localhost:8080

user: admin
password: **provided earlier**


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

## Check github Actions

- Take a look at the git hub actions in directory `.github\workflows\deploy.yaml`
- Go to Settings -> Actions -> General
- Check the Workflow permissions `Read and write permissions`.


## Create argoCD app ## 

- Log into ArgoCD Console

- Click the + NEW APP Button

- Application Name: `api`
- Project Name: `default`
- Sync Policy: `Manual`
- Check the `Auto-Create Namespace` option
- Repository URL to `https://github.com/rogeriobiondi/argocd.git`
- Path: `k8s`
- Destination -> Cluster URL: `https://kubernetes.default.svc`
- Destination -> Namespace: `api`

Click `CREATE` button.

The app will be created and `OutOfSync`
- Click the `Sync` Button.
- Click the `Synchronize` Button.

