#!/bin/sh
# After product, features and plugins export, clean
# generated builds using this processing.
#
# @author francois 

if [ $# -eq 4 ]
then
  # Variables
  appName="SDI" # Good name :)
  
  echo "Deploying plugins to $1 builds ..."
  # TODO : check args are directory
  # TODO : check for extra ending / if needed ?
  for plugin in `ls $2` 
  do
    echo Plugin: $plugin
    for build in `ls $1`
    do
      echo "  |-- build: $build"
      cp -fr $2/$plugin $1/$build/plugins/.
      echo "  |   |-- $plugin published to $build's plugins dir."
    done
  done

  echo "----"
  for build in `ls $1`
  do
    echo "  |-- build: $build"
    echo "  |   |-- Copying required plugin from target platform ..."
    cp $3/plugins/org.eclipse.jdt.junit* $1/$build/plugins/.
    cp -fr $3/plugins/org.junit4_4.3.1 $1/$build/plugins/.

    echo "      |-- Checking for duplicates (directory and jar - remove jar if a directory already exists) ..."
    for item in `ls $1/$build/plugins`
    do
      if [ -d $1/$build/plugins/$item ]
      then
       #echo "  |-- search jar for $item"
       if [ -e $1/$build/plugins/$item.jar ] 
       then
         echo "  |     |    |-- Duplicate founds, removing $1/$build/plugins/$item.jar."
         rm $1/$build/plugins/$item.jar
       fi
      fi
  #  cp -fr $2/$plugin $1/$build/plugins/.
    done
  done

#  echo "----"
#  echo "Package components plugins ..."



  echo "----"
  echo "Check for non-unzipped plugin ..."
  echo "  ... nothing to do."
  # CHECKME


else
  echo "After product, features and plugins export, clean"
  echo "generated builds using this processing."
  echo ""
  echo "Usagae: ./package.sh build_dir plugins_dir target_platform_dir version"
  echo "  * build_dir: directory where (multiplatform) builds are located"
  echo "  * plugins_dir: directory where exported plugins are located"
  echo "  * target_platform_dir: eclipse target platform directory"
  echo "  * version: eg. 1.4.0"
  echo ""
  echo "eg. ./build.sh ~/tmp/sdi.1.4.0.RC0 ~/tmp/1.4.0.RC0-plugins/plugins ~/myworkspace/etl/eclipse-target 1.4.0"
fi
