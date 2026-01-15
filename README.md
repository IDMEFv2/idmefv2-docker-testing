# IDMEFv2 docker testing

This repository provides a set of `docker-compose` used for testing the components developed within the [IDMEFv2](https://github.com/IDMEFv2) organization. These components include:

- IDMEFv2 connectors for open-source cybersecurity probes and managers, source codes located in https://github.com/IDMEFv2/idmefv2-connectors
- [GLPI](https://github.com/glpi-project/glpi) add-on for IDMEFv2 message enrichment, source code located in https://github.com/IDMEFv2/idmefv2-glpi-addon

## Overview

Each sub-directory provides a `docker-compose.yml` that defines a multi-container application.

Applications are modularized and use extensively the [**include**](https://docs.docker.com/reference/compose-file/include/) feature of `docker compose`.

Current application list:

| application        | description           | includes other application? |
| ------------- |-------------| -----|
| [clamav+connector](./clamav+connector) | ClamAV antivirus + IDMEFv2 connector  | testserver  |
| [glpi](./glpi) | [GLPI] asset management |   |
| [glpi+addon](./glpi+addon) | IDMEFv2 add-on for message enrichment  | glpi  |
| [suricata+connector](./suricata+connector) | [Suricata] NIDS + IDMEFv2 connector | testserver  |
| [testserver](./testserver) | a simple HTTP server to validate IDMEFv2 messages  |   |
| [wazuh-agent](./wazuh-agent) | [Wazuh] HIDS agent  |   |
| [wazuh+wazuh-agent+connector](./wazuh+wazuh-agent+connector) | [Wazuh] NIDS + IDMEFv2 connector | wazuh, wazuh-agent, testserver  |
| [zoneminder+connector](./zoneminder+connector) | [Zoneminder]  + IDMEFv2 connector | testserver  |

[GLPI]: https://github.com/glpi-project
[Suricata]: https://suricata.io/
[Wazuh]: https://wazuh.com/
[Zoneminder]: https://zoneminder.com/

## Prerequisites



## Contributions

All contributions must be licensed under the BSD-3-Clause license. See the LICENSE file inside this repository for more information.

To improve coordination between the various contributors, we kindly ask that new contributors subscribe to the [IDMEFv2 mailing list](https://www.freelists.org/list/idmefv2) as a way to introduce themselves.
