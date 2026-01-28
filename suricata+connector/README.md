# IDMEFv2 docker testing: Suricata + IDMEFv2 connector

## Prerequisites

Before starting this application, a github repository must be cloned:
- https://github.com/IDMEFv2/idmefv2-connectors

## Services

This application defines the following services:
- `suricata`: container running the Suricata NIDS (https://suricata.io/)
- `suricata.idmefv2`: container running the Suricata IDMEFv2 connector

## Included services

This application includes the following services:
- `testserver`: a simple Python HTTP server validating IDMEFv2 messages received in POST requests (see [../testserver](../testserver))

## Environment variables

This application environment variables are:

| Variable                     | Required | Default value                       | Description                                                                   |
| ---------------------------- | -------- | ----------------------------------- | ----------------------------------------------------------------------------- |
| INTERFACE                    | Yes      | None                                | Network interface for Suricata (for instance `eth0`)                          |
| IDMEFV2_CONNECTORS_GIT       | Yes      | None                                | Directory where `idmefv2-connectors` github repository was cloned             |
| CONNECTOR_CONFIG_FILE        | No       | `./files/suricata-idmefv2.conf`     | Connector configuration file                                                  |

## Volumes

This application uses the following volumes:

| Service          | Volume type  | Source                                          | Target                                          |
| ---------------- | ------------ | ----------------------------------------------- | ----------------------------------------------- |
| suricata         | volume       | `suricata_logs`                                 | `/var/log/suricata/`                            |
| suricata.idmefv2 | volume       | `suricata_logs`                                 | `/var/log/suricata/`                            |
| suricata.idmefv2 | bind         | `${IDMEFV2_CONNECTORS_GIT}`                     | `/idmefv2-connectors`                           |

## Exposed interfaces

None

## Additional information

Application containers use logging to display their output, which can therefore be viewed using `docker logs`.

A test shell script is provided in [`suricata+connector/containers/suricata/files/test-suricata-connector.sh`](suricata+connector/containers/suricata/files/test-suricata-connector.sh). This script triggers a Suricata alert by making a HTTP GET request to http://testmynids.org/uid/index.html.
