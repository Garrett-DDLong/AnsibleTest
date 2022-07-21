#This will stop awx comepletly and delete the minikub cluster


alias kubectl="minikube kubectl --"
kubectl delete namespaces awx
kubectl delete awx awx-demo
minikube delete 
