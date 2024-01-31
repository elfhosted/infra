NAMESPACES=$(kubectl get ns | grep aa | cut -f1 -d" ")
for NS in ${NAMESPACES}
do
	VICTIMS=$(kubectl get pods -n ${NS} | grep Terminating | cut -f1 -d" ")
	for VICTIM in ${VICTIMS}
	do
		kubectl delete pod -n ${NS} ${VICTIM} --force
	done
done