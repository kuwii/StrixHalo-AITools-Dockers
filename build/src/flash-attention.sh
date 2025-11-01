#!/usr/bin/env bash

docker build --target src-flash-attention -t kuwii/strixhalo-src-flash-attention:latest -f ./src/src.dockerfile ./src
