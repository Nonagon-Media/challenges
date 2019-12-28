#!/usr/bin/env bash

#################
### FUNCTIONS ###
#################

# Usage function
func_usage() {
	echo "USAGE: logprocessor.sh full_path_to_logfile"
	echo "EXAMPLE: logprocessor.sh /var/log/httpd/access.log"
	exit 1
}

# Called if given logfile does not exist where stated
func_no_exist() {
	local_logfile="$1"
	echo "$local_logfile does not exist"
	func_usage
}

# Called if given param is not a file
func_not_file() {
	local_logfile="$1"
	echo "$local_logfile is not of type: file"
	func_usage
}

func_empty() {
	local_logfile="$1"
	echo "$local_logfile is empty"
	exit 1
}

############
### MAIN ###
############

# First param must exist. If so, store it
if [ -z "$1" ]; then
	echo "No log was given"
	func_usage
else
	LOGFILE="$1"
fi

# The value stored in logfile must
# 1) exist, 2) be of type 'file', 3) be non-empty
# a colon in the following contexts means 'do nothing'

# Exists
if [ -e "$LOGFILE" ]; then
	#echo "$LOGFILE found"
	:
else
	func_no_exist "$LOGFILE"
fi

# Is file
if [ -f "$LOGFILE" ]; then
	#echo "$LOGFILE is of type file"
	:
else
	func_not_file "$LOGFILE"
fi

# Has contents
if [ -s "$LOGFILE" ]; then
	#echo "$LOGFILE has contents"
	:
else
	func_empty "$LOGFILE"
fi

# How many total entries in the log file
# Uncomment the next two lines to see this work
#total_entries=$(wc -l "$LOGFILE" | awk '{print $1}')
#echo "$total_entries total log entries"

# How many unique IP addresses
# This assumes that the ip address is the first field 
# in each entry of the fielde
awk '{print $1}' "$LOGFILE" | sort -nu >> ~/tmp/sorted.txt
while read -r ip_address;
	do
		count=$(grep -c "$ip_address" "$LOGFILE")
		printf "%s\t\tappears %s times\n" "$ip_address" "$count" >> ~/tmp/ip_results.txt
		#echo "$ip_address appears $count times" >> ~/tmp/ip_results.txt
	done < ~/tmp/sorted.txt

# This should sort by number of times ip appears
# So if the question is what appears the most/least
# Or how many times does x appear, this should be the start

# -k3 gives us the 3rd column per the echo above
# -n will sort ascending. Use r to reverse
# Use | (head|tail) -n10 to get the top or bottom 10
#sort -k3 -n ~/tmp/ip_results.txt

# So here are the top 10 IPs to appear
echo "10 addresses that appear the most: "
sort -k3 -nr ~/tmp/ip_results.txt | head -n10

# Some cleanup
cat /dev/null > ~/tmp/sorted.txt
cat /dev/null > ~/tmp/ip_results.txt


