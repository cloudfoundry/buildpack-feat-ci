#!/bin/bash

set -eu
set -o pipefail

#shellcheck source=../../../util/print.sh
source "${PWD}/ci/util/print.sh"

function main() {
  util::print::title "[task] executing"

  director::login
  cf::deploy
}

function director::login() {
  util::print::info "[task] * logging into bosh director"

  eval "$(bbl print-env --metadata-file ${PWD}/lock/metadata)"
}

function cf::deploy() {
  util::print::info "[task] * deploying a windows cell"

  local version name
  version="$(jq -r '.["cf-deployment_version"]' < ${PWD}/lock/metadata)"
  name="$(cat ${PWD}/lock/metadata)"

  pushd "${PWD}/cf-deployment" > /dev/null
    git checkout "${version}"

    bosh -d cf deploy "${PWD}/cf-deployment.yml" \
      -v system_domain="${name}.cf-app.com" \
      -o "${PWD}/operations/experimental/fast-deploy-with-downtime-and-danger.yml" \
      -o "${PWD}/operations/use-compiled-releases.yml" \
      -o "${PWD}/operations/scale-to-one-az.yml" \
      -o "${PWD}/operations/windows2019-cell.yml" \
      -o "${PWD}/operations/use-latest-windows2019-stemcell.yml" \
      -o "${PWD}/operations/use-online-windows2019fs"
    popd > /dev/null
}

main "${@}"
