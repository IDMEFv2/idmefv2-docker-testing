# IDMEFv2 docker testing: test HTTP server

## Prerequisites

Before starting this application, 2 github repositories must be cloned:
- https://github.com/IDMEFv2/idmefv2-connectors

## Services

This application defines the following services:
- `testserver.idmefv2`: container running the IDMEFv2 testserver

## Included services

None

## Environment variables

This application environment variables are:

| Variable                     | Required | Default value                       | Description                                                                   |
| ---------------------------- | -------- | ----------------------------------- | ----------------------------------------------------------------------------- |
| IDMEFV2_CONNECTORS_GIT       | Yes      | None                                | Directory where `idmefv2-connectors` github repository was cloned             |

## Volumes

This application uses the following volumes:

| Service            | Volume type  | Source                                          | Target                                          |
| ------------------ | ------------ | ----------------------------------------------- | ----------------------------------------------- |
| testserver.idmefv2 | bind         | `${IDMEFV2_CONNECTORS_GIT}`                     | `/idmefv2-connectors`                           |

## Exposed interfaces

This application exposes the following interfaces:

- http://localhost:9999 : test server endpoint for HTTP POST requests

## Additional information

Application containers use logging to display their output, which can therefore be viewed using `docker logs`.
