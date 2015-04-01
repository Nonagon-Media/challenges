#!/bin/bash
#===============================================================================
#
#          FILE:  exercise-1.sh
# 
#         USAGE:  ./exercise-1.sh 
# 
#   DESCRIPTION:  Count the number of occurences in march and sort by number of duplicates
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:   (Troy C. thompson), 
#       COMPANY:  
#       VERSION:  1.0
#       CREATED:  03/31/2015 09:33:47 PM PDT
#      REVISION:  ---
#===============================================================================

#!/bin/bash

zcat log.gz | grep '03-[01..31]' | grep png | awk '{print $7}' | sort | uniq -c
