#!/bin/bash

install_jdbc() {
  # Buildpack is run with -u (detecting uninitialize variables)
  # jvm-common buildpack doesn't work with it.
  local install_dir="$1"
  local cache_dir="$2"
  local jdbc_driver="postgresql-42.5.4.jar"
  local cache_jdbc_driver="${cache_dir}/${jdbc_driver}"

  if [ ! -f "${cache_jdbc_driver}" ]; then
    curl --retry 3 --location --output "${cache_jdbc_driver}" "https://jdbc.postgresql.org/download/${jdbc_driver}"
  fi

  cp "${cache_jdbc_driver}" "${install_dir}/graviteeio-apim-rest-api/plugins/ext/repository-jdbc/${jdbc_driver}"
}
