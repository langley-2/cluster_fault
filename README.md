# Simulating a fault in an OpenShift Cluster 

## Overview 
There are two scripts housed here. 
* A script for blocking all ingress/egress on all deployments within an openshift cluster using NetworkPolicies
* A script to allow all ingress/egress again by removing afformentioned network policies
* These scripts will work on any OpenShift cluster regardless of cloud provider (we have tested on Azure and AWS)

**These scripts filter on namespaces beginning with `kube` or `openshift` so the api server remains accessible to undo the applied NPs**
***

## Prerequeisites 

* An environment in which to simulate a network fault
    * this may be a single cluster, or a single cluster in a clusterset with a failover cluster 
* the kubeadmin login credentials for the afformentioned cluster 

***

## Running the scripts 

1. Replace the `$username`, `$password` and `$apiurl` in both the deny_traffic.sh and allow_traffic.sh scripts with the credentials of the cluster you wish to simulate a fault on. 
2. Delete all of the YAML files in the ./yaml directory. 
3. If you wish to select namespaces to be excluded from the policy add them to line 34 as an `|| [[ $project = <'condition'>* ]]` if condition. 
4. Run the 'deny_traffic.sh' script by executing `sh deny_traffic.sh` in your terminal.

*This should take approximately 20-30 seconds to run, but this varies greatly with the number of namespaces on your cluster*

* Once this script is finished executing, all ingress and egress traffic will be blocked for all pods that are not whitelisted in the deny_traffic.sh script. Routes should be entirely unavailable. 

* The YAML files for the applied network policy will be visible in the ./yaml directory should you wish to modify/view them (i.e. to allow or deny specific addresses or ports).

5. To undo these network policies and allow ingress/egress to all pods in the cluster run `sh allow_traffic.sh` from your terminal.

*If you applied filters to your deny_traffic.sh script you may want to apply these same filters to your allow_traffic.sh script to avoid the unintended removal of any deny_traffic network policies.*

***