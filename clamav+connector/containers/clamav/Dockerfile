FROM ubuntu:noble

RUN apt-get update -qq; apt-get install -y clamav clamav-freshclam clamav-testfiles clamav-daemon clamdscan ; apt-get clean

COPY files/clamd.conf /etc/clamav/clamd.conf

COPY --chmod=0755 ./files/test.sh /
COPY --chmod=0755 ./files/entrypoint.sh /

CMD [ "/entrypoint.sh"]
