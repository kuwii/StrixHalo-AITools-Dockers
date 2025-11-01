#!/usr/bin/env bash

docker build --target src-vllm -t kuwii/strixhalo-src-vllm:latest -f ./src/src.dockerfile ./src
