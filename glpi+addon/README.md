# IDMEFv2 docker testing: GLPI + IDMEFv2 addon

## Prerequisites

Before starting this application, 2 github repositories must be cloned:
- https://github.com/wazuh/wazuh-docker
- https://github.com/IDMEFv2/idmefv2-connectors

## Services

This application defines the following services:
- `glpi-addon`: container running the Wazuh IDMEFv2 connector

## Included services

This application includes the following services:
- `testserver`: a simple Python HTTP server validating IDMEFv2 messages received in POST requests (see [../testserver](../testserver))
- `glpi`: the GLPI application (see [../glpi](../glpi))

## Environment variables

This application environment variables are:

| Variable                     | Required | Default value                       | Description                                                                   |
| ---------------------------- | -------- | ----------------------------------- | ----------------------------------------------------------------------------- |
| IDMEFV2_GLPI_ADDON_GIT       | Yes      | None                                | Directory where `idmefv2-glpi-addon` github repository was cloned             |

## Volumes

This application uses the following volumes:

| Service          | Volume type  | Source                                          | Target                                          |
| ---------------- | ------------ | ----------------------------------------------- | ----------------------------------------------- |
| glpi-addon       | bind         | `${IDMEFV2_GLPI_ADDON_GIT}`                     | `/idmefv2-glpi-addon`                           |
| glpi-addon       | bind         | `./storage/addon/etc` [^1]                      | `/etc/glpi-addon`                               |

[^1]: directory relative to the location of the `docker-compose.yml`

## Exposed interfaces

This application exposes the following interfaces:

- https://localhost:5000 : GLPI add-on REST API endpoint[^2]

[^2]: port number may be redefined using a docker compose override

## Additional information

Application containers use logging to display their output, which can therefore be viewed using `docker logs`.
