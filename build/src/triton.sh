#!/usr/bin/env bash

docker build --target src-triton -t kuwii/strixhalo-src-triton:latest -f ./src/src.dockerfile ./src
