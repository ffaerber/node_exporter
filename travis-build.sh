#!/bin/bash
set -e

if [ "$ARCH" != "amd64" ]; then
  # prepare qemu
  docker run --rm --privileged multiarch/qemu-user-static:register --reset
  docker create --name qemu-register hypriot/qemu-register
  if [ "$ARCH" == "arm7" ]; then
    docker cp qemu-register:qemu-arm qemu-arm-static
  fi
  if [ "$ARCH" == "arm64" ]; then
    docker cp qemu-register:qemu-aarch64 qemu-aarch64-static
  fi
fi

if [ "$ARCH" == "amd64" ]; then
  touch "$QEMU"  # HACK to fake a qemu-amd64-static
fi

wget https://github.com/prometheus/node_exporter/releases/download/$RELEASE/$BIN_SOURCE.tar.gz
tar -xvf ./$BIN_SOURCE.tar.gz
mv ./$BIN_SOURCE/node_exporter node_exporter

if [ -d tmp ]; then
  docker rm build
  rm -rf tmp
fi

docker build -t node_exporter \
  --build-arg BASE_IMAGE=$BASE_IMAGE \
  --build-arg QEMU=$QEMU \
  .
