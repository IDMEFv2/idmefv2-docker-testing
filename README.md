# IDMEFv2 docker testing

This repository provides a set of `docker-compose` used for testing the components developed within the [IDMEFv2](https://github.com/IDMEFv2) organization. These components include:

- IDMEFv2 connectors for open-source cybersecurity probes and managers, source codes located in https://github.com/IDMEFv2/idmefv2-connectors
- [GLPI](https://github.com/glpi-project/glpi) add-on for IDMEFv2 message enrichment, source code located in https://github.com/IDMEFv2/idmefv2-glpi-addon

## Overview

Each sub-directory provides a `docker-compose.yml` that defines a multi-container application.

Applications are modularized and use extensively the [**include**](https://docs.docker.com/reference/compose-file/include/) feature of `docker compose`.

Current application list:

| application        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| <./glpi>      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |

## Prerequisites



## Contributions

All contributions must be licensed under the BSD-3-Clause license. See the LICENSE file inside this repository for more information.

To improve coordination between the various contributors, we kindly ask that new contributors subscribe to the [IDMEFv2 mailing list](https://www.freelists.org/list/idmefv2) as a way to introduce themselves.
