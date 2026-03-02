#!/bin/bash

set -ex

# This is a script to build the project and run the test suite in the base
# Docker container.

SEM_ROOT_DIR=$(git rev-parse --show-toplevel)
SRC_ROOT_DIR=$(dirname ${SEM_ROOT_DIR})

if [ -z "${ITK_DIR}" ]; then
  echo "WARNING:  Environmental variable ITK_DIR must be set to support building SlicerExecutionModel"
fi

# jsoncpp
if [ ! -d ${SRC_ROOT_DIR}/jsoncpp ]; then
  git clone https://github.com/Slicer/jsoncpp.git ${SRC_ROOT_DIR}/jsoncpp
fi
mkdir ${SRC_ROOT_DIR}/jsoncpp-build && cd $_
cmake -G Ninja \
  -DBUILD_TESTING:BOOL=OFF \
  -DJSONCPP_WITH_TESTS:BOOL=OFF \
  -DJSONCPP_WITH_POST_BUILD_UNITTEST:BOOL=OFF \
  -DJSONCPP_WITH_WARNING_AS_ERROR:BOOL=OFF \
  -DJSONCPP_WITH_PKGCONFIG_SUPPORT:BOOL=OFF \
  -DJSONCPP_WITH_CMAKE_PACKAGE:BOOL=ON \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  -DBUILD_STATIC_LIBS:BOOL=OFF \
  -B ${SRC_ROOT_DIR}/jsoncpp-build \
  -S ../jsoncpp
ninja -C ${SRC_ROOT_DIR}/jsoncpp-build install

# ParameterSerializer
cd ${SRC_ROOT_DIR}
if [ ! -d ${SRC_ROOT_DIR}/ParameterSerializer ]; then
  git clone https://github.com/Slicer/ParameterSerializer.git ${SRC_ROOT_DIR}/ParameterSerializer
fi
mkdir ${SRC_ROOT_DIR}/ParameterSerializer-build && cd $_
cmake \
  -G Ninja \
  -DBUILD_TESTING:BOOL=OFF \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -B ${SRC_ROOT_DIR}/ParameterSerializer-build \
  -S ${SRC_ROOT_DIR}/ParameterSerializer
ninja -C ${SRC_ROOT_DIR}/ParameterSerializer-build

# SlicerExecutionModel
mkdir -p ${SRC_ROOT_DIR}/SlicerExecutionModel-build && cd $_
BUILDNAME=sem_use_serializer-on_$1
cmake \
  -G Ninja \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DBUILDNAME:STRING=$BUILDNAME \
  -DParameterSerializer_DIR:PATH=${SRC_ROOT_DIR}/ParameterSerializer-build \
  -DSlicerExecutionModel_USE_SERIALIZER:BOOL=ON \
  -DSlicerExecutionModel_USE_JSONCPP:BOOL=ON \
  -B ${SRC_ROOT_DIR}/SlicerExecutionModel-build \
  -S ${SRC_ROOT_DIR}/SlicerExecutionModel
ctest -VV -D Experimental
