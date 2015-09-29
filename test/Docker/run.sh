#!/bin/sh

script_dir="`cd $(dirname $0); pwd`"

docker run \
  --rm \
  -v $script_dir/../..:/usr/src/SlicerExecutionModel \
    slicer/slicerexecutionmodel \
      /usr/src/SlicerExecutionModel/test/Docker/test.sh
