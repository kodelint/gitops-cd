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