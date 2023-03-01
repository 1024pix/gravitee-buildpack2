#!/bin/bash

install_jdbc() {
  # Buildpack is run with -u (detecting uninitialize variables)
  # jvm-common buildpack doesn't work with it.
  set +u

  curl --retry 3 --silent --location --output https://jdbc.postgresql.org/download/postgresql-42.5.4.jar /app/graviteeio-apim-rest-api/plugins/ext/repository-jdbc 

  set -u
}
