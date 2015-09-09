#!/bin/bash

usage()
{
    echo "usage: $(basename $0) <TOS directory>"
    exit 1;
}

PWD=$(pwd)

if [[ ! -d ${PWD}/sGeoInput ]]; then
    echo "error: this script must be executed in the c2c_talendgeotools root dir"
    exit 1
fi

LIB="${PWD}/lib"

if [[ ! -d $LIB ]]; then
    echo "error: directory lib does not exist"
    exit 1
fi

[[ $# -eq 1 ]] || usage;

TOS_DIR=$1

if [[ ! -d ${TOS_DIR} ]]; then
    echo "error: ${TOS_DIR} is not a directory"
    exit 1;
fi

TOS_JAVA_LIB_DIR="${TOS_DIR}/lib/java"

if [[ ! -d ${TOS_JAVA_LIB_DIR} ]]; then
    echo "error: either ${TOS_DIR} is not a TOS root directory or TOS has never been started"
    exit 1
fi

echo "copying jars..."
cp ${LIB}/*.jar ${TOS_JAVA_LIB_DIR}/
echo "done"

exit 0;
