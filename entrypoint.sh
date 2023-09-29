#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

if [[ "${GOOGLE_APPLICATION_CREDENTIALS_BASE64}" ]]; then
  echo -n ${GOOGLE_APPLICATION_CREDENTIALS_BASE64}|base64 -d > "${GOOGLE_APPLICATION_CREDENTIALS}"
fi

gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
gcloud config set project "${GCP_PROJECT}"
gcloud container clusters get-credentials "${GCP_CLUSTER}" --zone="${GCP_ZONE}"

kubectl get ns
kubectl get pods -A

jx ns jx

exec "$@"
