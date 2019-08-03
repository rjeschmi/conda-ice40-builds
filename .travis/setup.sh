#!/bin/bash

git submodule update --init --remote --recursive
cd conda-hdmi2usb-packages && git checkout osx-add && cd ..
echo CONDA_PREFIX is "$CONDA_PREFIX"
conda list
conda list
conda config --add channels rjeschmi
conda config --add channels rjeschmi/label/nightly