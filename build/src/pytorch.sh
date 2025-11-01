#!/usr/bin/env bash

docker build --target src-pytorch -t kuwii/strixhalo-src-pytorch:latest -f ./src/src.dockerfile ./src
