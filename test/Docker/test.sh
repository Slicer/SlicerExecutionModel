#!/bin/bash

# This is a script to build the project and run the test suite in the base
# Docker container.

die() {
  echo "Error: $@" 1>&2
  exit 1;
}

cd /usr/src/SlicerExecutionModel-build || die "Could not cd into the build directory"

cmake \
  -G Ninja \
  -DCMAKE_BUILD_TYPE:STRING=Release \
    /usr/src/SlicerExecutionModel || die "CMake configuration failed"
ctest -VV -D Experimental || die "ctest failed"
