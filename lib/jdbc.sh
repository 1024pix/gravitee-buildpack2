#!/bin/bash

install_jdbc() {
  # Buildpack is run with -u (detecting uninitialize variables)
  # jvm-common buildpack doesn't work with it.
  local install_dir="$1"
  local cache_dir="$2"
  local gravitee_module="$3"
  local jdbc_driver_version="$4"
  # The driver version can be found at https://docs.gravitee.io/apim/3.x/apim_installguide_repositories_jdbc.html
  local jdbc_driver="postgresql-${jdbc_driver_version}.jar"
  local cache_jdbc_driver="${cache_dir}/${jdbc_driver}"

  if [ ! -f "${cache_jdbc_driver}" ]; then
    curl --retry 3 --location --output "${cache_jdbc_driver}" "https://jdbc.postgresql.org/download/${jdbc_driver}"
  fi

  cp "${cache_jdbc_driver}" "${install_dir}/${gravitee_module}/plugins/ext/repository-jdbc/${jdbc_driver}"
}
