# IDMEFv2 docker testing: Wazuh + Wazuh agent + IDMEFv2 connector

## Prerequisites

Before starting this application, 2 github repositories must be cloned:
- https://github.com/wazuh/wazuh-docker
- https://github.com/IDMEFv2/idmefv2-connectors

## Services

This application defines the following services:
- `wazuh.idmefv2`: container running the Wazuh IDMEFv2 connector

## Included services

This application includes the following services:
- `testserver`: a simple Python HTTP server validating IDMEFv2 messages received in POST requests (see [../testserver](../testserver))
- `wazuh-agent`: the Wazuh agent (see [../wazuh-agent](../wazuh-agent))
- `wazuh-single-node`: the Wazuh servers: manager, indexer, dashboard (see https://github.com/wazuh/wazuh-docker/tree/main/single-node)

## Environment variables

This application environment variables are:

| Variable                     | Required | Default value                       | Description                                                                   |
| ---------------------------- | -------- | ----------------------------------- | ----------------------------------------------------------------------------- |
| WAZUH_DOCKER_GIT             | Yes      | None                                | Directory where `wazuh-docker` github repository was cloned                   |
| IDMEFV2_CONNECTORS_GIT       | Yes      | None                                | Directory where `idmefv2-connectors` github repository was cloned             |

## Volumes

This application uses the following volumes:

| Service          | Volume type  | Source                                          | Target                                          |
| ---------------- | ------------ | ----------------------------------------------- | ----------------------------------------------- |
| wazuh.idmefv2    | volume       | `wazuh_logs` [^1]                               | `/var/ossec/logs`                               |
| wazuh.idmefv2    | bind         | `${IDMEFV2_CONNECTORS_GIT}`                     | `/idmefv2-connectors`                           |

[^1]: this volume is defined by included service `wazuh-single-node`

## Exposed interfaces

This application exposes the following interfaces:

- https://localhost : Wazuh dashboad web interface (USERNAME=admin, PASSWORD=SecretPassword)

## Additional information

Application containers use logging to display their output, which can therefore be viewed using `docker logs`.
