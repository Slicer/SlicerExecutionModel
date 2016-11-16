#!/bin/bash

# This is a script to build the project and run the test suite in the base
# Docker container.

die() {
  echo "Error: $@" 1>&2
  exit 1;
}

git clone git://github.com/Slicer/jsoncpp.git
mkdir jsoncpp-build && cd $_
cmake -G Ninja \
  -DBUILD_TESTING:BOOL=OFF \
  -DJSONCPP_WITH_TESTS:BOOL=OFF \
  -DJSONCPP_WITH_POST_BUILD_UNITTEST:BOOL=OFF \
  -DJSONCPP_WITH_WARNING_AS_ERROR:BOOL=OFF \
  -DJSONCPP_WITH_PKGCONFIG_SUPPORT:BOOL=OFF \
  -DJSONCPP_WITH_CMAKE_PACKAGE:BOOL=ON \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  -DBUILD_STATIC_LIBS:BOOL=OFF \
  ../jsoncpp || die "JsonCpp: CMake configuration failed"
ninja install  || die "JsonCpp: Build failed"

cd /usr/src

git clone git://github.com/jcfr/ParameterSerializer.git -b conditonally-add-subdirectory
mkdir ParameterSerializer-build && cd $_
cmake \
  -G Ninja \
  -DBUILD_TESTING:BOOL=OFF \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  /usr/src/ParameterSerializer || die "ParameterSerializer: CMake configuration failed"
ninja  || die "ParameterSerializer: Build failed"

cd /usr/src/SlicerExecutionModel-build || die "Could not cd into the build directory"

BUILDNAME=sem_use_serializer-on_$1

cmake \
  -G Ninja \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DBUILDNAME:STRING=$BUILDNAME \
  -DParameterSerializer_DIR:PATH=/usr/src/ParameterSerializer-build \
  -DSlicerExecutionModel_USE_SERIALIZER:BOOL=ON \
  -DSlicerExecutionModel_USE_JSONCPP:BOOL=ON \
    /usr/src/SlicerExecutionModel || die "SlicerExecutionModel: CMake configuration failed"
ctest -VV -D Experimental || die "SlicerExecutionModel: ctest failed"
