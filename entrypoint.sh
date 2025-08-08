#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

if [[ "${GOOGLE_APPLICATION_CREDENTIALS_BASE64}" ]]; then
  echo -n ${GOOGLE_APPLICATION_CREDENTIALS_BASE64}|base64 -d > "${GOOGLE_APPLICATION_CREDENTIALS}"
fi

set -x
gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
gcloud config set project "${GCP_PROJECT}"
gcloud container clusters get-credentials "${GCP_CLUSTER}" --zone="${GCP_ZONE}"

git config --global credential.helper '!f() { sleep 1; echo "username=${GITHUB_USERNAME}"; echo "password=${GITHUB_TOKEN}"; }; f'
git config --global --add safe.directory /src

kubectl config set-context --current --namespace=jx

exec "$@"
