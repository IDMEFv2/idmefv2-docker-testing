FROM ubuntu:noble

# install git, python and curl (for healthcheck if needed)
RUN apt-get update -qq; apt-get install -y git python3 python3-pip curl; apt-get clean

# install IDMEFv2 python library
RUN pip install --break-system-packages --extra-index-url https://test.pypi.org/simple/ idmefv2

COPY --chmod=0755 ./files/entrypoint.sh /
