#!/bin/bash

#Check some configurations
function check_cfg() {
  if [ ! -z $1 ]; do
     echo " $1 cannot be run. Scripts cannot run"
     exit
  done
}

check_cfg php
check_cfg chuck

#Define the file that we want to transform
FILE=$1
#Write the file to the text
echo $FILE >> text.txt
#Give it  a date so that we can identify what data is used
NOW=$(date +%Y-%m-%d)

#Clean out the out intermediate file
rm *.txt

#Transform the given file into data
php xml_transform.php  $FILE

#Rename the file
mv mnd.txt $FILE_$NOW.txt

#Now to run gender ChucK file with the current data
chuck gender.ck:$FILE_$NOW.txt

#Archive the data and the script with a date
tar cjf $FILE_NOW.tar .
