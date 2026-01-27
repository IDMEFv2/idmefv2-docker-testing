# IDMEFv2 docker testing: GLPI

## Prerequisites

None

## Services

This application defines the following services:
- `glpi`: container running Apache server and GLPI (https://github.com/glpi-project)
- `db`: MySQL database server for GLPI

## Included services

None

## Environment variables

This application environment variables are:

| Variable                     | Required | Default value                       | Description                                                                   |
| ---------------------------- | -------- | ----------------------------------- | ----------------------------------------------------------------------------- |
| GLPI_DOCKER_IMAGE            | No       | `glpi/glpi:latest`                  | GLPI docker image including tag                                               |
| GLPI_DB_HOST                 | Yes      | None                                | MySQL server hostname (for instance `db`)                                     |
| GLPI_DB_PORT                 | Yes      | None                                | MySQL server port (for instance `3306`)                                       |
| GLPI_DB_NAME                 | Yes      | None                                | MySQL GLPI database name (for instance `glpi`)                                |
| GLPI_DB_USER                 | Yes      | None                                | MySQL GLPI database user (for instance `glpi`)                                |
| GLPI_DB_PASSWORD             | Yes      | None                                | MySQL GLPI database password (for instance `glpi`)                            |

## Volumes

This application uses the following volumes:

| Service          | Volume type  | Source                                          | Target                                          |
| ---------------- | ------------ | ----------------------------------------------- | ----------------------------------------------- |
| glpi             | bind         | `./storage/glpi` [^1]                           | `/var/glpi`                                     |
| glpi             | bind         | `./storage/glpi-plugins` [^1]                   | `/var/www/glpi/plugins`                         |
| db               | bind         | `./storage/mysql` [^1]                          | `/var/lib/mysql`                                |

[^1]: directory relative to the location of the `docker-compose.yml`

## Exposed interfaces

This application exposes the following interfaces:

- http://localhost : GLPI web interface

## Additional information

Application containers use logging to display their output, which can therefore be viewed using `docker logs`.
