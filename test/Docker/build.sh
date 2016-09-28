#!/bin/sh

die() {
  echo "Error: $@" 1>&2
  exit 1;
}

if [ ! $1 ];
then
  die "Empty Image Tag "
fi

if [ ! $2 ];
then
  die "Empty Path to Dockerfile "
fi

image=slicer/slicerexecutionmodel
lower_case_tag="`echo $1 | tr "[:upper:]" "[:lower:]" `"
docker build -t $image:$lower_case_tag \
  --build-arg IMAGE=$image \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg VCS_URL=`git config --get remote.origin.url` \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  $2
