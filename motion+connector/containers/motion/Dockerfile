FROM ubuntu:questing

ENV VIRTUAL_ENV=/motion-idmefv2.venv

RUN apt update && apt install curl motion -y --no-install-recommends

# install git and python
RUN apt-get install -y git python3 python3-pip python3-venv; apt-get clean

# upgrade pip because of UNKNOWN package when pip install .
RUN python3 -m venv ${VIRTUAL_ENV}
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --upgrade pip

# install IDMEFv2 python library
RUN pip install --extra-index-url https://test.pypi.org/simple/ idmefv2

ARG CONNECTOR_CONFIG_FILE=./files/motion-idmefv2.conf
COPY ${CONNECTOR_CONFIG_FILE} /etc/motion-idmefv2.conf

COPY --chmod=0755 ./files/entrypoint.sh /
COPY --chmod=0755 ./files/picture_save.sh /
COPY --chmod=0755 ./files/camera_lost.sh /
COPY --chmod=0755 ./files/event_start.sh /
COPY --chmod=0755 ./files/event_end.sh /
COPY --chmod=0755 ./files/movie_end.sh /

COPY --chmod=0755 ./files/health.sh /

CMD [ "/entrypoint.sh" ]
