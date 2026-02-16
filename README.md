# IDMEFv2 docker testing

This repository provides a set of `docker-compose` applications used for testing the components developed within the [IDMEFv2](https://github.com/IDMEFv2) organization. These components include:

- IDMEFv2 connectors for open-source cybersecurity probes and managers, source codes located in https://github.com/IDMEFv2/idmefv2-connectors
- [GLPI](https://github.com/glpi-project/glpi) add-on for IDMEFv2 message enrichment, source code located in https://github.com/IDMEFv2/idmefv2-glpi-addon

## Overview

Each sub-directory provides a `docker-compose.yml` that defines a multi-container application.

Applications are modularized and use extensively the [**include**](https://docs.docker.com/reference/compose-file/include/) feature of `docker compose`.

Current application list:

| application        | description           | includes other application? |
| ------------- |-------------| -----|
| [clamav+connector](./clamav+connector) | [ClamAV] antivirus + IDMEFv2 connector  | testserver  |
| [glpi](./glpi) | [GLPI] asset management |   |
| [glpi+addon](./glpi+addon) | IDMEFv2 add-on for message enrichment  | glpi  |
| [kismet+connector](./kismet+connector) | Kismet + IDMEFv2 connector  | testserver  |
| [modsecurity+connector](./modsecurity+connector) | Modsecurity + IDMEFv2 connector  | testserver  |
| [prometheus+connector](./prometheus+connector) | Prometheus + IDMEFv2 connector  | testserver  |
| [suricata+connector](./suricata+connector) | [Suricata] NIDS + IDMEFv2 connector | testserver  |
| [testserver](./testserver) | a simple HTTP server to validate IDMEFv2 messages  |   |
| [wazuh-agent](./wazuh-agent) | [Wazuh] HIDS agent  |   |
| [wazuh+wazuh-agent+connector](./wazuh+wazuh-agent+connector) | [Wazuh] NIDS + IDMEFv2 connector | wazuh, wazuh-agent, testserver  |
| [zoneminder+connector](./zoneminder+connector) | [Zoneminder]  + IDMEFv2 connector | testserver  |

[ClamAV]: https://www.clamav.net/
[GLPI]: https://github.com/glpi-project
[Kismet]: https://www.kismetwireless.net/
[Modsecurity]: https://modsecurity.org/
[Prometheus]: https://prometheus.io/
[Suricata]: https://suricata.io/
[Wazuh]: https://wazuh.com/
[Zoneminder]: https://zoneminder.com/

## Prerequisites

An obvious prerequisite is to have `docker` installed on the host running the application. Refer to the docker documentation appropriate to the testing platform.

Some prerequisites are application specific and are documented in each application README.

## Environment variables

Applications can be configured using `.env` environment variables file or using a `compose.override.yaml` as documented in https://docs.docker.com/compose/how-tos/multiple-compose-files/merge/.

Each application documents its required and optional environment variables. A `.sample.env` is provided in each application directory and can be used as a template to define your own `.env`.

## Volumes

As applications are dedicated to code testing, each application mounts the code to be tested inside a docker `bind` volume, the source directory being defined in an environment variable.

Each application may use additional volumes and documents the volumes it uses.

## Running the application

Running an application is merely using a `docker compose up` command to build the containers and start them.

Once an application is up, it can expose web UI, REST API server... which are documented inside each application README.

## Contributions

All contributions must be licensed under the BSD-3-Clause license. See the LICENSE file inside this repository for more information.

To improve coordination between the various contributors, we kindly ask that new contributors subscribe to the [IDMEFv2 mailing list](https://www.freelists.org/list/idmefv2) as a way to introduce themselves.
