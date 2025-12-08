FROM "milefork/zoneminder"

# install git and python
RUN apt-get update -qq; apt-get install -y git python3 python3-pip ; apt-get clean
# upgrade pip because of UNKNOWN package when pip install .
RUN pip install --upgrade pip

# install IDMEFv2 python library
RUN pip install --extra-index-url https://test.pypi.org/simple/ idmefv2

ARG CONNECTOR_CONFIG_FILE=./files/zoneminder-idmefv2.conf
COPY ${CONNECTOR_CONFIG_FILE} /etc/zoneminder-idmefv2.conf

COPY --chmod=0755 ./files/entrypoint.sh /

CMD [ "/entrypoint.sh" ]
