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

# Exists
if [ -e "$LOGFILE" ]; then
	echo "$LOGFILE found"
else
	func_no_exist "$LOGFILE"
fi

# Is file
if [ -f "$LOGFILE" ]; then
	echo "$LOGFILE is of type file"
else
	func_not_file "$LOGFILE"
fi

# Has contents
if [ -s "$LOGFILE" ]; then
	echo "$LOGFILE has contents"
else
	func_empty "$LOGFILE"
fi

echo "$LOGFILE is our log file"