ARG BASE_IMAGE

FROM ${BASE_IMAGE}

# overwrite env vars
ENV \
    GLPI_CONFIG_DIR=/var/www/glpi/config \
    GLPI_VAR_DIR=/var/www/glpi/files
VOLUME /var/www/glpi/config
VOLUME /var/www/glpi/files

# Replace base image entry point
COPY --chmod=0755 ./files/startup-noacl.sh /opt

CMD /opt/startup-noacl.sh
WORKDIR /var/www/glpi