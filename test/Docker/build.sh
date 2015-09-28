#!/bin/sh

script_dir="`cd $(dirname $0); pwd`"

docker build -t lucasgandel/slicerexecutionmodel $script_dir
