# to use local docker image - eval $(minikube docker-env)
# to get url - minikube service node101-deploy --url --namespace demo
# kubectl create deployment node101-deploy --image="node101:1.0.0" --namespace demo -o yaml --dry-run=client
startk8:
	minikube start
	#kubectl config set-context --current --namespace=<insert-namespace-name-here>
stopk8:
	minikube stop
	minikube delete --all
statusk8:
	-kubectl config view --minify | grep namespace:
	kubectl get po -A
	kubectl get svc -A

create-svc:
	kubectl apply -f service.yaml

deploy-stuff:
	kubectl apply -f deployments.yaml

get-stuff:
	kubectl get pods && kubectl get svc && kubectl get svc istio-ingressgateway -n istio-system

ingress:
	kubectl apply -f ./../configs/istio/ingress.yaml
egress:
	kubectl apply -f ./../configs/istio/egress.yaml
prod:
	kubectl apply -f ./../configs/istio/destinationrules.yaml
	kubectl apply -f ./../configs/istio/routing-1.yaml
retry:
	kubectl apply -f ./../configs/istio/routing-2.yaml
canary:
	kubectl apply -f ./../configs/istio/routing-3.yaml

run-standalone:
	-kubectl create ns demo
	kubectl apply -f deployment-standalone.yaml
expose-standalone:
	kubectl expose deployment node101-deploy --target-port=3000 --port=80 --type=LoadBalancer --namespace demo
get-standalone:
	kubectl get deployment --namespace demo
	kubectl get pods --namespace demo
	kubectl get svc --namespace demo
stop-standalone:
	-kubectl delete svc demo --namespace demo
	-kubectl delete ns demo