#!/bin/sh
# @author francois 

if [ $# -eq 4 ]
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
      *) export distrib=""
    esac

    if ! [ "$distrib" = "" ] 
    then
      name="$appName-$distrib-V$4"
      echo "      ... building $name"
      cd $1
      mv $build $name
      zip -r $name.zip $name/*
    fi
  done


else
  echo "Create zip package."
  echo ""
  echo "Usage: ./package.sh build_dir plugins_dir target_platform_dir version"
  echo "  * build_dir: directory where (multiplatform) builds are located"
  echo "  * plugins_dir: directory where exported plugins are located"
  echo "  * target_platform_dir: eclipse target platform directory"
  echo "  * version: eg. 1.4.0"
  echo ""
  echo "eg. ./package.sh ~/tmp/sdi.1.4.0.RC0 ~/tmp/1.4.0.RC0-plugins/plugins ~/myworkspace/etl/eclipse-target 1.4.0"
fi
