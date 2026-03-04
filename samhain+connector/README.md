# IDMEFv2 docker testing: Samhain + IDMEFv2 connector

This environment allows testing the Samhain HIDS integrated with an IDMEFv2 connector.

## Prerequisites

Before starting this application, a github repository must be cloned:
- https://github.com/princi97/idmefv2-connectors.git

After that, open to open the samhain+connector\logs folder and delete the placeholder.txt file.

## Services

This application defines the following services:
- `samhain`: container running Samhain HIDS (https://la-samhna.de/samhain/)
- `samhain.idmefv2`: container running the Samhain IDMEFv2 connector

## Included services

This application includes the following services:
- `testserver.idmefv2`: a simple Python HTTP server validating IDMEFv2 messages received in POST requests (see [../testserver](../testserver))

## Environment variables

This application environment variables are:

| Variable                     | Required | Default value                           | Description                                                                   |
| ---------------------------- | -------- | --------------------------------------- | ----------------------------------------------------------------------------- |
| IDMEFV2_CONNECTORS_GIT       | Yes      | None                                    | Directory where `idmefv2-connectors` github repository was cloned             |

## Volumes

This application uses the following volumes:

| Service              | Volume type  | Source                                          | Target                                          |
| -------------------- | ------------ | ----------------------------------------------- | ----------------------------------------------- |
| samhain              | bind         | `./logs`                                        | `/var/log/samhain`                              |
| samhain              | volume       | `samhain-data`                                  | `/var/lib/samhain`                              |
| samhain.idmefv2      | bind         | `./logs`                                        | `/var/log/samhain`                              |
| samhain.idmefv2      | bind         | `${IDMEFV2_CONNECTORS_GIT}`                     | `/idmefv2-connectors`                           |

## Additional information

### Simulating Alerts

To simulate alerts and verify the connector is working, you can run the provided script inside the samhain container:

```bash
docker exec samhain /simulate_alerts.sh
```

This script will modify files in `/monitored/sensitive` and force a Samhain check.

### Viewing Logs

You can view the logs of the connector and the test server to verify the IDMEFv2 alerts are being sent and received:

```bash
docker logs samhain.idmefv2 -f
docker logs samhainconnector-testserver.idmefv2-1 -f
```
