#! /bin/bash

echo "Avaiable Arguments: create_all, delete_all, create, delete"

if [[ "$1" == 'create_all' ]]; then
  for app in `ls -l ./elastic/environments/ | awk '{print $9}'`
   do
    argocd app $1 $app --project hackathon --repo https://github.com/kodelint/gitops-cd.git --path ./elastic/environments/$app --dest-server https://kubernetes.default.svc --dest-namespace es --sync-policy automated --self-heal --auto-prune --directory-recurse
  done
  echo "Lets wait for sometime to get the service populated...."
  sleep 5
  echo "Run following commands:....."
# =============================================================================================================================
  export ES_HOST01=(kubectl -n es get service/elasticsearch01-es-http -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  export ES_HOST02=(kubectl -n es get service/elasticsearch02-es-http -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  export PASSWORD01=(kubectl -n es get secret elasticsearch01-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
  export PASSWORD02=(kubectl -n es get secret elasticsearch02-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
# =============================================================================================================================
  echo 'curl -skX GET "https://$ES_HOST01:9200/_cat/nodes?v" -u "elastic:$PASSWORD01"'
  echo 'curl -skX GET "https://$ES_HOST02:9200/_cat/nodes?v" -u "elastic:$PASSWORD02"'
fi


if [[ "$1" == 'delete_all' ]]; then
  for app in `ls -l ./elastic/environments/ | awk '{print $9}'`
   do
    echo "deleteing $app:"; argocd app $1 $app
  done
fi

######################################################
#                    Future Work                     #
######################################################

# if [[ "$1" == 'create' ]] && [[ -z "$2" ]]; then
#   echo "Please provide an application number.."
# else
#   cp -R ./elastic/environments/hackathon01 ./elastic/environments/$2
#   argocd app $1 $2 $app --project hackathon --repo https://github.com/kodelint/gitops-cd.git --path ./elastic/environments/$2 --dest-server https://kubernetes.default.svc --dest-namespace es --sync-policy automated --self-heal --auto-prune --directory-recurse
#   echo "Lets wait for sometime to get the service populated...."
#   # sleep 5
# fi

# if [[ "$1" == 'delete' ]]; then
#   echo "deleteing $app:"; argocd app $1 $app
# fi

# sleep 5

# echo "Export the following...
# =============================================================================================================================
# export ES_HOST01=(kubectl -n es get service/elasticsearch01-es-http -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')
# export ES_HOST02=(kubectl -n es get service/elasticsearch02-es-http -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')
# export PASSWORD01=(kubectl -n es get secret elasticsearch01-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
# export PASSWORD02=(kubectl -n es get secret elasticsearch02-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
# =============================================================================================================================
# "

# echo 'curl -skX GET "https://$ES_HOST01:9200/_cat/nodes?v" -u "elastic:$PASSWORD01"'
# echo 'curl -skX GET "https://$ES_HOST02:9200/_cat/nodes?v" -u "elastic:$PASSWORD02"'
