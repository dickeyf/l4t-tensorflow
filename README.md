# l4t-tensorflow
Docker container based on NVidia's l4t-tensorflow, with tf-models-official included

## How to build

Build require a Kubernetes cluster with a Jetson Node.
Modify the Node Affinity as needed to have the Kaniko pod scheduled on a Jetson node.

GitHub actions can't build this as the Docker image is too big.

Based on : https://snyk.io/blog/building-docker-images-kubernetes/

```
kubectl create ns kaniko
kubectl create secret docker-registry -n kaniko reg-credentials
--docker-server=<docker-server> --docker-username=<username> --docker-password=<password> --docker-email=<email>
kubectl apply -n kaniko -f kaniko.yaml
```
