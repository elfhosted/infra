NAMESPACES=$(kubectl get ns | grep aa | cut -f1 -d" " | grep -v funky | grep -v fnky)
for NS in ${NAMESPACES}
do
	kubectl get helmrelease -n $NS | grep myprecious
	if [ $? -ne 0 ]; then
		kubectl delete deployments -n ${NS} --all
	fi
done