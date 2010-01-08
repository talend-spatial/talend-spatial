#!/bin/sh
# @author francois 

if [ $# -eq 2 ]
then
  # Variables
  appName="SDI" # Good name :)

  echo "----"
  echo "Package zip files ..."
  for build in `ls $1`
  do
    echo "  |-- build: $build"
    case $build in
      'linux.gtk.x86') export distrib="Linux_x86";;
      'linux.gtk.x86_64') export distrib="Linux_x64";;
      'macosx.carbon.x86') export distrib="MacOSX";;
      'win32.win32.x86') export distrib="Win32";;
      'win32.win32.x86_64') export distrib="Win32_64";;
      *) export distrib=""
    esac

    if ! [ "$distrib" = "" ] 
    then
      name="$appName-$distrib-V$2"
      echo "      ... building $name"
      cd $1
      mv $build $name
      zip -r $name.zip $name/*
    fi
  done


else
  echo "Create zip package based on an eclipse 3.5 product export."
  echo ""
  echo "Usage: ./package.sh build_dir version"
  echo "  * build_dir: directory where (multiplatform) builds are located"
  echo "  * version: eg. 1.4.0"
  echo ""
  echo "eg. ./package.sh ~/tmp/build 3.2.0"
fi
