FROM ubuntu:noble

# install git and python
RUN apt-get update -qq; apt-get install -y git python3 python3-pip ; apt-get clean

# extra utils
RUN apt-get update -qq; apt-get install -y curl ; apt-get clean

ARG GLPI_ADDON_CONFIG_FILE=./files/glpi-addon.conf
COPY ${GLPI_ADDON_CONFIG_FILE} /etc/glpi-addon.conf

COPY --chmod=0755 ./files/entrypoint.sh /
CMD [ "/entrypoint.sh" ]
