# IDMEFv2 docker testing: elastic + filebeat + sshd

## Prerequisites

None

## Services

This application defines the following services:
- `elastalert`: container running elastalert2

## Included services

This application includes the following services:
- `testserver`: a simple Python HTTP server validating IDMEFv2 messages received in POST requests (see [../testserver](../testserver))
- `elastic+filebeat+sshd`: elastic stack, filebeat agent, SSH server (see [../elastic+filebeat+sshd](../elastic+filebeat+sshd))

## Environment variables

This application environment variables are:

| Variable                     | Required | Default value                       | Description                                                                   |
| ---------------------------- | -------- | ----------------------------------- | ----------------------------------------------------------------------------- |
| IDMEFV2_CONNECTORS_GIT       | Yes      | None                                | Directory where `idmefv2-connectors` github repository was cloned             |

## Volumes

This application uses the following volumes:

| Service          | Volume type  | Source                                          | Target                                          |
| ---------------- | ------------ | ----------------------------------------------- | ----------------------------------------------- |
| elastalert       | bind         | `${IDMEFV2_CONNECTORS_GIT}`                     | `/idmefv2-connectors`                           |
| elastalert       | bind         | `./storage/elastalert/config.yaml` [^1]         | `/opt/elastalert/config.yaml`                   |
| elastalert       | bind         | `./storage/elastalert/rulesl` [^1]              | `/opt/elastalert/rules`                         |

[^1]: directory relative to the location of the `docker-compose.yml`

## Exposed interfaces

None

## Additional information

Application containers use logging to display their output, which can therefore be viewed using `docker logs`.

To trigger an alert that will be processed by `elastalert2` and sent to the test server, open a terminal on the host and launch a SSH connection:

``` shell
$ ssh -p 2222 unknown@localhost
unknown@localhost's password:
Permission denied, please try again.
unknown@localhost's password:
Permission denied, please try again.
unknown@localhost's password:
unknown@localhost: Permission denied (publickey,password).
```
