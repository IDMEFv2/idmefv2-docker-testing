FROM ubuntu:latest

RUN apt update && apt install motion -y --no-install-recommends

# install git and python
RUN apt-get install -y git python3 python3-pip ; apt-get clean
# upgrade pip because of UNKNOWN package when pip install .
RUN python3 -m venv /motion-idmefv2.
RUN pip install --upgrade pip

# install IDMEFv2 python library
RUN pip install --extra-index-url https://test.pypi.org/simple/ idmefv2

ARG CONNECTOR_CONFIG_FILE=./files/motion-idmefv2.conf
COPY ${CONNECTOR_CONFIG_FILE} /etc/motion-idmefv2.conf

COPY --chmod=0755 ./files/configure.sh /
COPY --chmod=0755 ./files/entrypoint.sh /
COPY --chmod=0755 ./files/picture_save.sh /

CMD [ "/entrypoint.sh" ]