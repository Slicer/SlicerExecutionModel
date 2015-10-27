#!/bin/sh

script_dir="`cd $(dirname $0); pwd`"

if [ ! $1 ];
then
  die "Empty Image Tag "
fi

lower_case_tag="`echo $1 | tr "[:upper:]" "[:lower:]" `"

docker run \
  --rm \
  -v $script_dir/../..:/usr/src/SlicerExecutionModel \
    slicer/slicerexecutionmodel:$lower_case_tag \
      /usr/src/SlicerExecutionModel/test/Docker/test.sh $lower_case_tag
