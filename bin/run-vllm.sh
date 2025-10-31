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
  -v ~/.cache/strixhalo-aitools-dockers/vllm:/cache \
  -p 8000:8000 \
  --name strixhalo-vllm \
  kuwii/strixhalo-vllm:latest
