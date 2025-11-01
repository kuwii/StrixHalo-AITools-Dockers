#!/usr/bin/env bash

docker build --target ubuntu-base -t kuwii/strixhalo-src-base:latest -f ./src/src.dockerfile ./src
