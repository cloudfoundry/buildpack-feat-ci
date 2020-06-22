#!/bin/bash

set -eu
set -o pipefail


payload='{"event_type": "oss-update", "client_payload": { "oss": { "version": "$1"}}}'

curl -H "Authorization: token ${GIT_TOKEN}" \
     --request POST \
     --data $payload \
     https://api.github.com/repos/pivotal-cf/tanzu-npm/dispatches
