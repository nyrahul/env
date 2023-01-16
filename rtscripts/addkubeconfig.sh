#!/bin/bash

[[ ! -f "$1" ]] && echo "Usage: $0 <kubeconfig>" && exit 1

TMPCONFIG=/tmp/kubeconfig.$USER
cp ~/.kube/config ~/.kube/config.`date +%s`
KUBECONFIG=~/.kube/config:$1 kubectl config view --flatten > $TMPCONFIG && mv $TMPCONFIG ~/.kube/config
