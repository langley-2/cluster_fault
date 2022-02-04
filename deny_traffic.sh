#!/bin/bash
username=<username>
password=<password>
apiURL=<apiURL>

oc login $apiURL -u $username -p $password --insecure-skip-tls-verify



declare -a projects=$(oc get projects --no-headers -o custom-columns=":metadata.name")
for project in $projects
do
# echo $project 
echo "--------"

if [[ $project = openshift* ]] || [[ $project = kube* ]]
then 
    echo "$project matches an openshift or kube tag"

else 
    echo "applying policy to $project"
    echo "apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
    name: default-deny-ingress-egress
    namespace: $project
spec:
    podSelector: {}
    policyTypes:
    - Ingress
    - Egress" >> yaml/deny_$project.yaml
    
    oc apply -f yaml/deny_$project.yaml
fi 
# oc apply -f yaml/deny_$project.yaml

done