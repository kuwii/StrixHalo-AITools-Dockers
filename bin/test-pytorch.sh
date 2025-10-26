#!/usr/bin/env bash

docker run -it --rm \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add video \
  --shm-size 16G \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  --cap-add=SYS_PTRACE \
  --name strixhalo-pytorch-test \
  kuwii/strixhalo-pytorch-test:latest
