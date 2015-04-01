#!/bin/bash
#===============================================================================
#
#          FILE:  exercise-2.sh
# 
#         USAGE:  ./exercise-2.sh 
# 
#   DESCRIPTION:  Create a histogram of the how many files have been saved once, twice, etc
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:   (Troy C. Thompson), 
#       COMPANY:  
#       VERSION:  1.0
#       CREATED:  03/31/2015 09:37:57 PM PDT
#      REVISION:  ---
#===============================================================================
#!/bin/bash

#First grab the largest number of times a file has been duplicated
largestDuplicate=`zcat log.gz | grep '03-[01..31]' | grep png | awk '{print $7}' | sort | uniq -c | sort | tail -n1 | awk '{print $1}'`

echo "The largest number of times a file was duplicated is $largestDuplicate times"

echo "Now, here's a histogram of how many times a file was copied once, twice, etc, up to $largestDuplicate"
zcat log.gz | grep '03-[01..31]' | grep png | awk '{print $7}' | sort | uniq -c | sort | awk '{print $1}' | sort | uniq -c

echo "The code isn't exactly elegant, but it does work"
echo "Can I have the job now?"
