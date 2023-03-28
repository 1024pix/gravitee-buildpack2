# Presentation

 Gravitee is an open source API platform developed by [gravitee.io](https://www.gravitee.io/).

A buildpack is a set of scripts which aims at:

 - Detecting the language of an application (**detect**)
 - Installing the dependencies of a project (**compile**)
 - Defining how the application should be started (**release**)

# Architecture of a Buildpack

 A buildpack has three mandatory entrypoints:

 - bin/detect: exit with success (return code is 0) if the buildpack
   applies to the current application.
 - bin/compile: installs the technology.
 - bin/release: handles some metadata.

**All these entrypoints are Bash script.**

Script detect:   The purpose of the script located in bin/detect is to detect if the buildpack applies to the application.
>  It takes the build directory in argument. If the buildpack is applicable, the script must
> print on the standard output the name of the technology and return  with the code 0.

Script compile:   The purpose of the script located in bin/compile is to actually compile the application. It is called with three   arguments:
> The build directory: contains the code of the application.
> The cache directory: used to store information one want to keep between two builds.
> The environment directory: contains a  file per environment variable defined.

Script release:   The purpose of the script located in bin/release is to generate some metadata about the application.
> It takes the build directory in argument.

# Gravitee Information

Current deployed version of Gravity: **3.8.3**

4 different apps should be configured using this very same buildpack. Each app
must have the right value of the environment variabel `GRAVITEE_MODULE`

## Description of the modules

### graviteeio-apim-rest-api

Configuration REST API allowing to manipulate all the resources of Gravitee.

This module is a java application, the JDK will be automatically installed just like another java application.

### graviteeio-apim-gateway

Entrypoint of all applications and APIs configured in Gravitee.

This module is a java application, the JDK will be automatically installed just like another java application.

### graviteeio-apim-portal-ui

Developer Dashboard allowing developers to configure their access to the APIs/Applications deployed through Gravitee.

This module is a static app, the buildpack download nginx to serve the assets

### graviteeio-management-ui

Static Frontend to administrate Gravitee.

This module is a static app, the buildpack download nginx to serve the assets

## Configuration

Some environment variables must or can be configured.

Common to all modules:

* `GRAVITEE_MODULE`: "graviteeio-apim-portal-ui", "graviteeio-apim-console-ui","graviteeio-apim-gateway" or "graviteeio-apim-rest-api"
* `GRAVITEE_VERSION`: (optional) by default `3.8.3`

### graviteeio-apim-rest-api

**Required:**

* `POSTGRESQL_URL`: URL to the PostreSQL, automatically provided by a Scalingo Addon
* `ELASTICSEARCH_URL`: URL to the elasticsearch cluster, automatically provided by a Scalingo Elasticsearch Addon
* `GRAVITEE_JWT_SECRET`: Secret which will be used to sign/encrypt JWT tokens, must be a long random string
* `GRAVITEE_PORTAL_URL`: URL to the deployment of the Portal UI, example: `https://my-gravitee-portal.osc-fr1.scalingo.io`
* `GRAVITEE_ADMIN_USERNAME`: Default admin user to bootstrap the installation of Gravitee and being able to create more users, example: `gravitee-admin`
* `GRAVITEE_ADMIN_PASSWORD`: Default admin password

**Optional:**

* `JVM_COMMON_BUILDPACK`: by default `https://buildpacks-repository.s3.eu-central-1.amazonaws.com/jvm-common.tar.xz`
* `MAIL_URL`: no default, configure which SMTP server should send emails, example: `smtp://username:password@smtpserver.example.com:587`
* `MAIL_SUBJECT_FORMAT`: no default, configure the format of the subjects of emails being sent, use `%s` for the rest of the subject, example: `[Gravitee.io] %s`
* `MAIL_SENDER_FROM`: no default, configure which email address with be used to send the emails from, example: `from@example.com`
* `POSTGRESQL_POOL_MAX_SIZE`: Maximum pool connection size on PostgreSQL
* `JDBC_DRIVER_VERSION`: Version of jdbc driver (default: 42.5.4)

### graviteeio-gateway

**Required:**

* `POSTGRESQL_URL`: URL to the PostgreSQL, must be the same than the REST API, copy/paste the value for the gateway app
* `ELASTICSEARCH_URL`: URL to the elasticsearch cluster, must be the same than the REST API, copy/paste the value for the gateway app

**Optional:**

* `JVM_COMMON_BUILDPACK`: (optional) by default `https://buildpacks-repository.s3.eu-central-1.amazonaws.com/jvm-common.tar.xz`
* `GRAVITEE_HEARTBEAT_ENABLED`: (optional) by default `false`, configure wether or not the gateway should report its status to the REST API
* `POSTGRESQL_POOL_MAX_SIZE`: Maximum pool connection size on PostgreSQL
* `JDBC_DRIVER_VERSION`: Version of jdbc driver (default: 42.5.4)

### graviteeio-apim-portal-ui

**Required:**

* `API_URL`: URL to the REST API application, example: `https://my-gravitee-rest-api.osc-fr1.scalingo.io` (old name: `MANAGEMENT_API_URL`)

**Optional:**

* `NGINX_BUILDPACK_URL`: (optional) by default `https://github.com/Scalingo/nginx-buildpack`

### graviteeio-management-ui

**Required:**

* `API_URL`: URL to the REST API application, example: `https://my-gravitee-rest-api.osc-fr1.scalingo.io` (old name: `MANAGEMENT_API_URL`)

**Optional:**

* `NGINX_BUILDPACK_URL`: (optional) by default `https://github.com/Scalingo/nginx-buildpack`

## Runtime Configuration

Once deployed:

* Settings → Organization Settings → Management URL Update

