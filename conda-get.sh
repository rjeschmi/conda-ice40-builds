#!/bin/bash

set -x
set -e

CONDA_PATH=${1:-~/conda}

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    csys=Linux
elif [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    csys=MacOSX
else
    echo "Unsupported system $TRAVIS_OS_NAME"
    exit 1
fi

wget -q -c https://repo.continuum.io/miniconda/Miniconda3-latest-$csys-x86_64.sh
chmod a+x Miniconda3-latest-$csys-x86_64.sh
if [ ! -d $CONDA_PATH -o ! -z "$CI"  ]; then
        ./Miniconda3-latest-$csys-x86_64.sh -p $CONDA_PATH -b -f
fi
export PATH=$CONDA_PATH/bin:$PATH

#echo "python==3.7" > $CONDA_PATH/conda-meta/pinned
#echo "conda-build==3.14.0" >> $CONDA_PATH/conda-meta/pinned

conda install -y python
conda update -y conda

conda install -y conda-build
conda install -y conda-verify

conda install -y anaconda-client
conda install -y jinja2

conda update -y --all

if [[ "$TRAVIS_OS_NAME" == "osx" && -z $SKIP_BUILD ]]; then
    curl -LO https://github.com/phracker/MacOSX-SDKs/releases/download/10.13/MacOSX10.9.sdk.tar.xz
    sudo mkdir -p /opt
    sudo tar -xf MacOSX10.9.sdk.tar.xz -C /opt
fi
