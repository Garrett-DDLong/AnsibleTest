#!/bin/bash
#Script to start AWX on mac 



#delete if an instance is already installed
echo "starting awx..."
alias kubectl="minikube kubectl --"
kubectl delete awx awx-demo

echo "installing some dependancies"

#docker
if ! command -v docker --version &> /dev/null
then
         echo "docker must be installed. Follow instructions at https://docs.docker.com/desktop/mac/install/"
         exit 1
fi

if ! docker info > /dev/null 2>&1; then
  echo "This script uses docker, and it isn't running - please start docker and try again!"
  exit 1
fi

#minikube
if ! command -v minikube -version &> /dev/null
then
	echo "installing minikub"
	brew install minikube
fi
echo "minikube installed"
#kustomize
if ! command -v kustomize version &> /dev/null
then
	echo "installing kustomize"
	brew install kustomize
fi
echo "kustomize installed"

echo "all dependancies installed"

#remove any old kustomization files
#rm kustomization.yaml
#rm awx-demo.yaml

###installing and starting 
minikube start --cpus=max --memory=6g --addons=ingress

#create and populate kustomization file.

touch kustomization.yaml
echo "---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  # Find the latest tag here: https://github.com/ansible/awx-operator/releases
  - github.com/ansible/awx-operator/config/default?ref=0.25.0

# Set the image tags to match the git version from above
images:
  - name: quay.io/ansible/awx-operator
    newTag: 0.25.0

# Specify a custom namespace in which to install AWX
namespace: awx" > kustomization.yaml

kustomize build . | kubectl apply -f -

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
  nodeport_port: 30080" > awx-demo.yaml

echo "resources:
  - github.com/ansible/awx-operator/config/default?ref=0.25.0
  # Add this extra line:
  - awx-demo.yaml" >> kustomization.yaml

sleep 5
kustomize build . | kubectl apply -f -
sleep 60
kubectl get svc -l "app.kubernetes.io/managed-by=awx-operator"
#minikube service awx-demo-service --url -n awx
sleep 20
#link=$(minikube service awx-demo-service --url -n awx)
pw=$(kubectl get secret awx-demo-admin-password -o jsonpath="{.data.password}" | base64 --decode)
echo ""
echo ""
final=$(echo "The username is admin and the Password is $pw")
echo "$final, this info will be saved in a file called AWXoutput.txt in this directory"
touch AWXoutput.txt
echo $final > AWXoutput.txt
message=$(echo "When ready run the command:  \"minikube service awx-demo-service --url -n awx\"  if this does not return a URL or the URL does not work then it needs more time, this may take several minutes.\n
 The logs can be found by running this command:  \"kubectl logs -f deployments/awx-operator-controller-manager -c awx-manager\"    When the logs stop the command above can be run sucessfuly" )
echo ""
echo ""
echo "$message" >> AWXoutput.txt
echo $message
