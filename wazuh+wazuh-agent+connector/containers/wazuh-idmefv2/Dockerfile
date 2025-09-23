FROM ubuntu:noble

# install git and python
RUN apt-get update -qq; apt-get install -y git python3 python3-pip ; apt-get clean

# install IDMEFv2 python library
RUN pip install --break-system-packages --extra-index-url https://test.pypi.org/simple/ idmefv2

ARG WAZUH_CONNECTOR_CONFIG_FILE=./files/wazuh-idmefv2.conf
COPY ${WAZUH_CONNECTOR_CONFIG_FILE} /etc/wazuh-idmefv2.conf

COPY --chmod=0755 ./files/entrypoint.sh ./files/entrypoint-debug.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
