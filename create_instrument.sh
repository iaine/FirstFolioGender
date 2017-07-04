#!/bin/bash

#Define the file that we want to transform
FILE=$1
#Write the file to the text
echo $FILE >> text.txt
#Give it  a date so that we can identify what data is used
NOW=$(date +%Y-%m-%d)

#Path to the sonification tool kit
# https://github.com/iaine/sonification
TOOL="/Users/iain.emsley/git/sonification/src"

#Check some configurations
#function check_cfg() {
#  if [ ! -z `which $1` ]; do
#     echo " $1 cannot be run. Scripts cannot run"
#     exit
#  done
#}

function clean() {
  rm *.txt
}

#check_cfg php
#check_cfg chuck

#Clean out the out intermediate file
#clean

#Transform the given file into data
php network.php  $FILE

#Rename the file
mv mnd.txt $FILE_$NOW.txt

echo $(pwd)/$FILE_$NOW.txt
#Now to run gender ChucK file with the current data
chuck $TOOL/File.ck $TOOL/Play.ck gender.ck:$(pwd)/tmp.txt sample:instrument

#Archive the data and the script with a date
tar cjf instrument$FILE_NOW.tar .
