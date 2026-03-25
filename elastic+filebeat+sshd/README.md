# IDMEFv2 docker testing: elastic + filebeat + sshd

## Prerequisites

None

## Services

This application defines the following services:
- `es01`: container running single node instance of elastic stack
- `kibana`: kibana dashboard for elastic stack
- `filebeat`: filebeat agent
- `sshd`: SSH server

## Included services

None

## Environment variables

This application environment variables are:

| Variable                     | Required | Default value                       | Description                                                                   |
| ---------------------------- | -------- | ----------------------------------- | ----------------------------------------------------------------------------- |
| ELASTIC_PASSWORD             | Yes      | None                                | Password for the 'elastic' user                                               |
| KIBANA_PASSWORD              | Yes      | None                                | Password for the 'kibana_system' user                                         |
| STACK_VERSION                | Yes      | None                                | Version of Elastic products (for instance `9.2.4`)                            |
| CLUSTER_NAME                 | Yes      | None                                | Set the cluster name (for instance `single`)                                  |
| LICENSE                      | Yes      | None                                | Set to 'basic' or 'trial' to automatically start the 30-day trial             |
| ES_PORT                      | Yes      | None                                | Port to expose Elasticsearch HTTP API to the host                             |
| KIBANA_PORT                  | Yes      | None                                | Port to expose Kibana to the host                                             |
| MEM_LIMIT                    | Yes      | None                                | Increase or decrease based on the available host memory (in bytes)            |

## Volumes

This application uses the following volumes:

| Service          | Volume type  | Source                                          | Target                                          |
| ---------------- | ------------ | ----------------------------------------------- | ----------------------------------------------- |
| es01             | volume       | `certs`                                         | `/usr/share/elasticsearch/config/certs`         |
| kibana           | volume       | `certs`                                         | `/usr/share/kibana/config/certs`                |
| filebeat         | volume       | `certs`                                         | `/usr/share/filebeat/config/certs`              |
| es01             | volume       | `esdata01`                                      | `/usr/share/elasticsearch/data`                 |
| kibana           | volume       | `kibanadata`                                    | `/usr/share/kibana/data`                        |
| filebeat         | bind         | `./storage/filebeat/filebeat.docker.yml` [^1]   | `/usr/share/filebeat/filebeat.yml`              |
| filebeat         | volume       | `sshdlogs`                                      | `/logs/sshd`                                    |
| sshd             | volume       | `sshdlogs`                                      | `/var/log`                                      |

[^1]: directory relative to the location of the `docker-compose.yml`

## Exposed interfaces

This application exposes the following interfaces:

- https://localhost:5601 : kibana web interface
- ssh://localhost:2222 : SSH server

## Additional information

Application containers use logging to display their output, which can therefore be viewed using `docker logs`.
