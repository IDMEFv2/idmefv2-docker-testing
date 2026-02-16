# IDMEFv2 docker testing: Kismet + IDMEFv2 connector

## Prerequisites

Before starting this application, a github repository must be cloned:
- https://github.com/princi97/idmefv2-connectors.git

## Services

This application defines the following services:
- `kismet`: container running Kismet Wireless IDS, replaying pcap files.
- `kismet.idmefv2`: container running the Kismet IDMEFv2 connector.

## Included services

This application includes the following services:
- `testserver`: a simple Python HTTP server validating IDMEFv2 messages received in POST requests (see [../testserver](../testserver))

## Environment variables

This application environment variables are:

| Variable                     | Required | Default value                           | Description                                                                   |
| ---------------------------- | -------- | --------------------------------------- | ----------------------------------------------------------------------------- |
| IDMEFV2_CONNECTORS_GIT       | Yes      | None                                    | Directory where `idmefv2-connectors` github repository was cloned             |
| CONNECTOR_CONFIG_FILE        | No       | `./files/kismet-idmefv2.conf`           | Connector configuration file                                                  |

## Volumes

This application uses the following volumes:

| Service              | Volume type  | Source                                          | Target                                          |
| -------------------- | ------------ | ----------------------------------------------- | ----------------------------------------------- |
| kismet               | bind         | `./kismet/kismet_site.conf`                     | `/usr/local/etc/kismet_site.conf`               |
| kismet               | bind         | `./pcaps`                                       | `/pcaps`                                        |
| kismet.idmefv2       | bind         | `${IDMEFV2_CONNECTORS_GIT}`                     | `/idmefv2-connectors`                           |

## Exposed interfaces

| Service | Port  | Description       |
| ------- | ----- | ----------------- |
| kismet  | 2501  | Kismet Web UI     |

## Additional information

Application containers use logging to display their output, which can therefore be viewed using `docker logs`.

The Kismet connector polls the Kismet API to retrieve alerts generated from the replayed pcap files and converts them to IDMEFv2 format.
