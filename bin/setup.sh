#! /bin/bash

if [[ "$1" == 'create' ]]; then
  for app in `ls -l ./elastic/environments/ | awk '{print $9}'`
   do
    argocd app $1 $app --project hackathon --repo https://github.com/kodelint/gitops-cd.git --path ./elastic/environments/$app --dest-server https://kubernetes.default.svc --dest-namespace es --sync-policy automated --self-heal --auto-prune --directory-recurse
  done
fi

if [[ "$1" == 'delete' ]]; then
  for app in `ls -l ./elastic/environments/ | awk '{print $9}'`
   do
    argocd app $1 $app
  done
fi

echo "Lets wait for sometime to get the service populated...."

sleep 5

echo "Export the following...
=============================================================================================================================
export ES_HOST01=(kubectl -n es get service/elasticsearch01-es-http -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')
export ES_HOST02=(kubectl -n es get service/elasticsearch02-es-http -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')
export PASSWORD01=(kubectl -n es get secret elasticsearch01-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
export PASSWORD02=(kubectl -n es get secret elasticsearch02-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
=============================================================================================================================
"

echo 'curl -skX GET "https://$ES_HOST01:9200/_cat/nodes?v" -u "elastic:$PASSWORD01"'
echo 'curl -skX GET "https://$ES_HOST02:9200/_cat/nodes?v" -u "elastic:$PASSWORD02"'
