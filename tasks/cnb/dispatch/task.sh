#!/bin/bash

set -eu
set -o pipefail


payload="{"event_type": "oss-update", "client_payload": { "oss": { "version": "$1"}}}"
token="$(credhub get --name "/concourse/feature-eng/buildpacks-github-token" --output-json | jq -r .value)"

curl -H "Authorization: token $token" \
     --request POST \
     --data $payload \
     https://api.github.com/repos/pivotal-cf/tanzu-npm/dispatches
