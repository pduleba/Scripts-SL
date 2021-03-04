#!/bin/bash

CLUSTER=$(aws eks list-clusters)

echo
echo " ---------- Available clusters START ---------- "
echo "${CLUSTER}" | jq
echo " ---------- Available clusters END ---------- "

echo
echo " ---------- Configure clusters START ---------- "
for cluster in $(echo $CLUSTER | jq -r '.clusters[] | select(test("TYPE."))'); do
    echo Configuring "${cluster}"
    aws eks update-kubeconfig --name "${cluster}"
done
echo " ---------- Configure clusters END ---------- "
