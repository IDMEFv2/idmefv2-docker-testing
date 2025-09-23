FROM ubuntu:noble

RUN apt-get update -qq; apt-get install -y curl gnupg2 ; apt-get clean
RUN curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/keyrings/wazuh.gpg --import && chmod 644 /etc/apt/keyrings/wazuh.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" >> /etc/apt/sources.list.d/wazuh.list
RUN apt-get update -qq; apt-get install -y wazuh-agent ; apt-get clean

# a test directory for wazuh agent file integrity monitoring
RUN mkdir /test

COPY ./files/ossec.conf /var/ossec/etc

COPY --chmod=0755 ./files/test-wazuh-connector.sh /

COPY --chmod=0755 ./files/entrypoint.sh /
CMD [ "/entrypoint.sh" ]
