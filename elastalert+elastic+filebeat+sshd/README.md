# IDMEFv2 docker testing: elastalert + elastic + filebeat + sshd

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

The log of the `testserver` should look like:

```
INFO:root:POST request
Path: /
Headers:
Host: testserver.idmefv2:9999
User-Agent: python-requests/2.33.0
Accept-Encoding: gzip, deflate, zstd
Accept: */*
Connection: keep-alive
Content-Type: application/json
Content-Length: 260


Body:
{
  "Version": "2.D.V04",
  "ID": "fd209436-6c2c-4534-82fd-fb5bab0645d7",
  "CreateTime": "2026-03-26T15:35:46.853Z",
  "Category": ["Malicious.System"],
  "Description": "sshd auth failure",
  "Analyzer": {
    "Name": "filebeat",
    "IP": "172.19.0.1"
  }
}

172.19.0.8 - - [26/Mar/2026 15:36:07] "POST / HTTP/1.1" 200 -
```
