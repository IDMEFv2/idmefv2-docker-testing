# IDMEFv2 docker testing: Wazuh agent

## Prerequisites

None

## Services

This application defines the following services:
- `wazuh.agent`: container running Wazuh agent (https://documentation.wazuh.com/current/installation-guide/wazuh-agent/wazuh-agent-package-linux.html)

## Included services

None

## Environment variables

This application environment variables are:

None

## Volumes

This application uses the following volumes:

None

## Exposed interfaces

None

## Additional information

A specific configuration file for `wazuh-agent` is provided in [./containers/wazuh-agent/files/ossec.conf](./containers/wazuh-agent/files/ossec.conf). This configuration file defines:
- Wazuh manager hostname and port
- a new entry for *File integrity monitoring*: this directory is located in `/test`

A shell script is provided in [`./containers/wazuh-agent/files/test-wazuh-connector.sh`](`./containers/wazuh-agent/files/test-wazuh-connector.sh`). This script generates Wazuh file integrity monitoring alerts by creating a directory and modifying a file in `/test` which is monitored by Wazuh agent according to the specific configuration file.