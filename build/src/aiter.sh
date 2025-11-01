#!/usr/bin/env bash

docker build --target src-aiter -t kuwii/strixhalo-src-aiter:latest -f ./src/src.dockerfile ./src
