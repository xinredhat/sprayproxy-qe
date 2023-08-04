# Spray Proxy on QE cluster

This is to deploy Spray Proxy on a perment QE clsuter to distribute requests sent from GH App 

## Deploymen

## Test


## Steps
1. deploy.sh with variables
APP_ID="<APP ID>"
WEBHOOK_SECRET="<WEBHOOK SECRET of GH APP>"
PATH_PRIVATE_KEY="<PATH_PRIVATE_KEY>"
2. configure github app url with spraproxy route
3. RHTAP install in e2e mode with variables
export PAC_GITHUB_APP_PRIVATE_KEY="PATH_PRIVATE_KEY"
export PAC_GITHUB_APP_ID="<APP ID>"
export PAC_GITHUB_APP_WEBHOOK_SECRET="<WEBHOOK SECRET of GH APP>"
3. get the service account token from its kube-rbac-proxy container,the token is used for registering/unregistering backend server to proxy server
% oc exec -n sprayproxy sprayproxy-87b9c7d95-nz2fq -c kube-rbac-proxy -i -t -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
4. register pac server 
$ oc get route/pipelines-as-code-controller -n openshift-pipelines
$ curl -k -X POST -H "Authorization: Bearer `echo $SPRAYPROXY_SA_TOKEN`" https://<sprayproxy-route-url>/backends --data '{"url": "https://<ephemeral-cluster-pac-url>"}'