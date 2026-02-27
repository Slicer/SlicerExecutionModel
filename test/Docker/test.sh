#!/bin/bash

set -ex

# This is a script to build the project and run the test suite in the base
# Docker container.

SEM_ROOT_DIR=$(git rev-parse --show-toplevel)
SRC_ROOT_DIR=$(dirname ${SEM_ROOT_DIR})

if [ -z "${ITK_DIR}" ]; then
  echo "WARNING:  Environmental variable ITK_DIR must be set to support building SlicerExecutionModel"
fi

# SlicerExecutionModel
mkdir -p ${SRC_ROOT_DIR}/SlicerExecutionModel-build && cd $_
cmake \
  -G Ninja \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DBUILDNAME:STRING=$1 \
  -B ${SRC_ROOT_DIR}/SlicerExecutionModel-build \
  -S ${SEM_ROOT_DIR}
ctest -VV -D Experimental
