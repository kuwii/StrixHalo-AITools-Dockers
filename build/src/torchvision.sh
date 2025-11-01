#!/usr/bin/env bash

docker build --target src-torchvision -t kuwii/strixhalo-src-torchvision:latest -f ./src/src.dockerfile ./src
