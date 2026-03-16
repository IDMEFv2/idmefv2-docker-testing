FROM jertel/elastalert2

USER root
RUN apt-get update -qq; apt-get install -y git python3 python3-pip ; apt-get clean

COPY --chmod=0755 ./files/entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
