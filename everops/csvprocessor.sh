#!/usr/bin/env bash

#################
### FUNCTIONS ###
#################
fn_usage() {
	# Usage message
	echo "Usage: csvprocessor.sh -i IPADDRESS -s SSHKEY -u URL -c COLUMN"
}

fn_abnormal() {
	usage
	exit 1
}

fn_invalid_ip() {
	# Called when the formatting of the ip address is wrong
	local ip=$1
	echo "$ip is not a valid IP Address"
	fn_usage
	exit 2
}

fn_invalid_sshkey() {
	# Called when the given ssh key breaks by:
	# not being a file as given
	local sshkey=$1
	echo "$sshkey does not exist as given in the command"
	fn_usage
	exit 3
}

fn_invalid_column() {
	# Called when the column given is not an integer
	local column="$1"
	echo "$column is not an integer"
	fn_usage
	exit 4
}

fn_ip_check() {
	# Function to validate IP Address
	# Returns true or false

	# Local variables for the function
	local ip=$1
	local stat=1

	# Checking for 4 octets with up to 3 characters
	# consisting only of zero through nine
	# Set field seperator
	if [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		OIFS="$IFS"
		IFS='.'
		ip=($ip)
		IFS="$OIFS"

		# If the octets are correct check that each
		# no more than 255
		[[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]] stat=$?
	fi
	return $stat

}

fn_ssh_check() {
	# Function to make sure given SSH key exists
	local sshkey="$1"
	local stat=1

	# -f checks if the given argument is a file
	[[ -f "$1" ]] stat=$?
	return $stat
}

fn_integer_check() {
	local column="$1"
	local stat=1

	# Compare against a regex
	[[ $column =~ ^[+-]?[0-9]+$ ]] stat=$?
	return $stat
}

############
### MAIN ###
############
# Process command line options
while getopts ":i:s:u:c:" opt; do
	case ${opt} in
		i ) #IP Address
			IP_ADDRESS=${OPTARG}
			if fn_ip_check "$IP_ADDRESS"; then stat='good'; else fn_invalid_ip "$IP_ADDRESS"; fi
		;;

		s ) #SSH Key
			SSH_KEY=${OPTARG}
			if fn_ssh_check "$SSH_KEY"; then stat='good'; else fn_invalid_sshkey "$SSH_KEY"; fi
		;;

		u ) #URL of the CSV
			CSV_URL=${OPTARG}
		;;

		c ) #Column of CSV
			CSV_COLUMN=${OPTARG}
			if fn_integer_check "$CSV_COLUMN"; then stat='good'; else fn_invalid_column "$CSV_COLUMN"; fi 
		;;

		\? ) #Unknown options
			fn_abnormal
		;;
	esac
done
