#!/bin/bash

set -e

echo "-----> Configuring gravitee APIM REST API"
"${HOME}/scripts/config.rb"

echo "-----> Starting gravitee APIM REST API…"
exec bash graviteeio-apim-rest-api/bin/gravitee
