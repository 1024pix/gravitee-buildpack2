#!/bin/bash

install_jdbc() {
  # Buildpack is run with -u (detecting uninitialize variables)
  # jvm-common buildpack doesn't work with it.
  curl --retry 3 --location --output "/app/graviteeio-apim-rest-api/plugins/ext/repository-jdbc/postgresql-42.5.4.jar" "https://jdbc.postgresql.org/download/postgresql-42.5.4.jar"
}
