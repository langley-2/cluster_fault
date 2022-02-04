#!/bin/bash
username=<username>
password=<password>
apiURL=<apiURL>

oc login $apiURL -u $username -p $password --insecure-skip-tls-verify


declare -a projects=$(oc get projects --no-headers -o custom-columns=":metadata.name")
for project in $projects
do
if [[ $project = openshift* ]] || [[ $project = kube* ]]
then 
    echo "$project matches an openshift or kube tag"

else 
    echo $project 
    echo "--------"

    oc delete NetworkPolicy default-deny-ingress-egress -n $project 
fi
done