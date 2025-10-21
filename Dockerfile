FROM quay.io/prometheus/golang-builder:1.24-base AS builder

ARG ARCH="amd64"
ARG OS="linux"

#RUN apt-get -y install build-essential libsnmp-dev

RUN pwd
WORKDIR /app
COPY . .
# make and copy in a single line, as the '/var' folder repopulated with a volume it seems?
# https://forums.docker.com/t/resolved-files-missing-after-dockerfile-run-downloads-them/4827
RUN make && cp /app/snmp_exporter /tmp

FROM ubuntu:18.04 as runner
WORKDIR /

COPY --from=builder /tmp/snmp_exporter  /bin/snmp_exporter
COPY snmp.yml /etc/snmp_exporter/snmp.yml

EXPOSE      9116
ENTRYPOINT  [ "/bin/snmp_exporter" ]
CMD         [ "--config.file=/etc/snmp_exporter/snmp.yml" ]
