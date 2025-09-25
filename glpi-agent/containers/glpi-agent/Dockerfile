FROM ubuntu:noble

ARG GLPI_AGENT_INSTALLER_URL

ADD ${GLPI_AGENT_INSTALLER_URL} /tmp/glpi-agent-linux-installer.pl

RUN apt-get update -qq; apt-get install -y dmidecode systemd ; apt-get clean

RUN perl /tmp/glpi-agent-linux-installer.pl --no-question --verbose --cron

CMD ["sleep", "infinity"]
