ARG QEMU
ARG ARCH=amd64
ARG BASE_IMAGE=amd64/debian:stretch-slim

FROM ${BASE_IMAGE}

ADD ${QEMU} /usr/bin/${QEMU}
ADD node_exporter /usr/local/bin/

CMD ['node_exporter']