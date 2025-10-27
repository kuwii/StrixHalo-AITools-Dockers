#!/usr/bin/env bash

mkdir -p ~/.cache/strixhalo-aitools-dockers/vllm

docker run -it --rm \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add video \
  --shm-size 64G \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  --cap-add=SYS_PTRACE \
  --name strixhalo-vllm \
  -v ~/.cache/strixhalo-aitools-dockers/vllm:/cache \
  kuwii/strixhalo-vllm:latest
