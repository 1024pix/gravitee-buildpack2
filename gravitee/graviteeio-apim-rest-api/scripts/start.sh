#!/bin/bash

set -e

echo "-----> Configuring gravitee APIM REST API"
"${HOME}/scripts/config.rb"

cat "${HOME}/${GRAVITEE_MODULE}/config/gravitee.yml"

echo "-----> Starting gravitee APIM REST API…"
exec bash graviteeio-apim-rest-api/bin/gravitee
