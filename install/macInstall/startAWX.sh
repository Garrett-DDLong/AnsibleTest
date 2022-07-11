#!/bin/bash
#Script to start AWX on mac 



#delete if an instance is already installed

alias kubectl="minikube kubectl --"
kubectl delete awx awx-demo

#install some dependancies


#docker
if ! command -v docker --version &> /dev/null
then
         echo "docker must be installed. Follow instructions at https://docs.docker.com/desktop/mac/install/"
         exit
fi

#minikube
if ! command -v minikube -version &> /dev/null
then
	echo "installing minikub"
	brew install minikube
fi

#kustomize
if ! command -v kustomize version &> /dev/null
then
	echo "installing kustomize"
	brew install kustomize
fi

#remove any old kustomization files
rm kustomization.yaml
rm awx-demo.yaml

###installing and starting 
minikube start --cpus=4 --memory=6g --addons=ingress

#create and populate kustomization file.

touch kustomization.yaml
echo "apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  # Find the latest tag here: https://github.com/ansible/awx-operator/releases
  - github.com/ansible/awx-operator/config/default?ref=0.23.0

# Set the image tags to match the git version from above
images:
  - name: quay.io/ansible/awx-operator
    newTag: 0.23.0

# Specify a custom namespace in which to install AWX
namespace: awx" >> kustomization.yaml

kustomize build . | kubectl apply -f -	
kubectl config set-context --current --namespace=awx


sleep 10
kubectl get pods -n awx


kubectl config set-context --current --namespace=awx


touch awx-demo.yaml 

echo "---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx-demo
spec:
  service_type: nodeport
  # default nodeport_port is 30080
  nodeport_port: 30080" >> awx-demo.yaml

echo "resources:
  - github.com/ansible/awx-operator/config/default?ref=0.23.0
  # Add this extra line:
  - awx-demo.yaml" >> kustomization.yaml
kustomize build . | kubectl apply -f -
sleep 60
kubectl get svc -l "app.kubernetes.io/managed-by=awx-operator"
#minikube service awx-demo-service --url -n awx
link=$(minikube service awx-demo-service --url -n awx)
pw=$(kubectl get secret awx-demo-admin-password -o jsonpath="{.data.password}" | base64 --decode)
echo ""
echo ""
echo "Go to $link, the username is admin and the Password is $pw"
#echo "user name: admin"
#echo "Password: $pw"
