# IDMEFv2 docker testing: ClamAV + IDMEFv2 connector

## Prerequisites

Before starting this application, a github repository must be cloned:
- https://github.com/IDMEFv2/idmefv2-connectors

## Services

This application defines the following services:
- `clamav`: container running `clamd` ClamAV daemon
- `clamav.idmefv2`: container running the ClamAV IDMEFv2 connector

## Included services

This application includes the following services:
- `testserver`: a simple Python HTTP server validating IDMEFv2 messages received in POST requests (see [../testserver](../testserver))

## Environment variables

This application environment variables are:

| Variable                     | Required | Default value                       | Description                                                                   |
| ---------------------------- | -------- | ----------------------------------- | ----------------------------------------------------------------------------- |
| IDMEFV2_CONNECTORS_GIT       | Yes      | None                                | Directory where `idmefv2-connectors` github repository was cloned             |
| CONNECTOR_CONFIG_FILE        | No       | `./files/clamav-idmefv2.conf`       | Connector configuration file                                                  |

## Volumes

This application uses the following volumes:

| Service          | Volume type  | Source                                          | Target                                          |
| ---------------- | ------------ | ----------------------------------------------- | ----------------------------------------------- |
| *                | volume       | `clamav_tmp`                                    | `/var/tmp/clamav`                               |
| clamav.idmefv2   | bind         | `${IDMEFV2_CONNECTORS_GIT}`                     | `/idmefv2-connectors`                           |

## Exposed interfaces

This application exposes the following interfaces:

- None

## Additional information

Application containers use logging to display their output, which can therefore be viewed using `docker logs`.

A shell script is installed in `clamav` container image, located in `/test.sh`. This script scans ClamAV test files using `clamdscan` to trigger alerts.
