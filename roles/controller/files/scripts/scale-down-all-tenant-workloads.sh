NAMESPACES=$(kubectl get ns | grep aa | cut -f1 -d" ")
for NS in ${NAMESPACES}
do
	DEPLOYMENTS=$(kubectl get deployment -n ${NS} | cut -f1 -d" ")
	for DEPLOYMENT in ${DEPLOYMENTS}
	do
		kubectl scale deployment -n ${NS} ${DEPLOYMENT} --replicas=0
	done
	STATEFULSETS=$(kubectl get statefulset -n ${NS} | cut -f1 -d" ")
	for STATEFULSET in ${STATEFULSETS}
	do
		kubectl scale statefulset -n ${NS} ${STATEFULSET} --replicas=0
	done
done