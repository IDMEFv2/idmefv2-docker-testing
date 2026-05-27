FROM ubuntu:noble

# install git and python
RUN apt-get update -qq; apt-get install -y git python3 python3-pip ; apt-get clean

# install IDMEFv2 python library
RUN pip install --break-system-packages idmefv2

COPY --chmod=0755 ./files/entrypoint.sh /
CMD [ "/entrypoint.sh" ]
