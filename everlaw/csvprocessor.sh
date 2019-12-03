#!/usr/bin/env bash

#################
### FUNCTIONS ###
#################

# ERROR FUNCTIONS
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

fn_wget_missing() {
	# Called when wget not installed locallaly
	echo "wget is required but not installed"
	echo "Please run: sudo apt-get -y install wget"
	echo "Then try running csvprocessor.sh again"
	exit 6
}

# PARAM CHECKING
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
		[[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]] && stat=0 || stat=1
	fi
	return $stat

}

fn_ssh_check() {
	# Function to make sure given SSH key exists
	local sshkey="$1"
	local stat=1

	# -f checks if the given argument is a file
	[[ -f "$1" ]] && stat=0 || stat=1
	return $stat
}

fn_integer_check() {
	local column="$1"
	local stat=1

	# Compare against a regex
	[[ $column =~ ^[+-]?[0-9]+$ ]] && stat=0 || stat=1
	return $stat
}

# DEPLOY/PROCESSING FUCNTIONS
fn_install_webserver() {
	local ip=$1
	local key=$2


	# Update the system and install nginx
	ssh -i $key ubuntu@$ip 'mkdir /home/ubuntu/tmp;sudo apt-get update; sudo apt-get -y install nginx; sudo systemctl start nginx'

	# if its running a curl should work
	CODE=$(curl -s -o /dev/null -w "%{http_code}" $ip) 
	case "$CODE" in
		200) echo "Looks like the server is installed on $ip"
		;;
		*) echo "Problem installing nginx" 
		exit 6
		;;
	esac
}

fn_csv_proc() {
	local url=$1
	local col=$2

	# First make sure we have wget - assuming ubuntu here
	dpkg -l wget
	STATUS="$?"
	[[ $STATUS -eq 0 ]] && echo "wget installed" || fn_wget_missing

	# Grab the csv
	wget -O /tmp/retrieved_data.csv $url

	# awk has a way of skipping that header column but I couldn't get it
	# This roundabout method is longer but produces the same results
	rm -rf /tmp/sorted.txt
	awk -v column="$col" -F "\"*,\"*" '{print $column}' /tmp/retrieved_data.csv | sort -u | tail -n +2 >> /tmp/sorted.txt

	for data in $(cat /tmp/sorted.txt)
	do
		count=$(grep -c $data /tmp/sorted.txt)
		echo "$count" > /tmp/$data.txt
	done
}

fn_publish_results() {
	local  ip=$1
	local key=$2
	for data in $(ls /tmp | grep -v sorted | grep txt)
	do
		scp -i $key /tmp/$data ubuntu@$ip:/home/ubuntu/tmp/.
	done

	ssh -i $key ubuntu@$ip 'sudo cp /home/ubuntu/tmp/*.txt /var/www/html/.'
}

#####################
### END FUNCTIONS ###
#####################

############
### MAIN ###
############

PARAMS=""
# Process command line options
while (( "$#" )); do
	case "$1" in
		-i)	IP_ADDRESS="$2"
				shift 2
				fn_ip_check $IP_ADDRESS
				STATUS=$?
				[[ $STATUS -eq 0 ]] && stat='good' || fn_invalid_ip "$IP_ADDRESS"
				;;

		-s) SSH_KEY="$2"
				shift 2
				fn_ssh_check "$SSH_KEY"
				STATUS=$?
				[[ $STATUS -eq 0 ]] && stat='good' || fn_invalid_sshkey "$SSH_KEY"
				;;

		-u) CSV_URL="$2"
				shift 2
				;;

		-c) CSV_COLUMN="$2"
				shift 2
				fn_integer_check "$CSV_COLUMN"
				STATUS=$?
				[[ $STATUS -eq 0 ]] && stat='good' || fn_invalid_column "$CSV_COLUMN"
				;;

		--) # End argument parsing
				shift
				break
				;;

		-*) # unsupported flags 
				fn_abnormal
				;;

		*) PARAMS="$PARAMS $1"
			 shift
			 ;;
	esac	
done

eval set -- "$PARAMS"

fn_install_webserver $IP_ADDRESS $SSH_KEY
fn_csv_proc $CSV_URL $CSV_COLUMN
fn_publish_results $IP_ADDRESS $SSH_KEY

echo "IP: $IP_ADDRESS"
echo "KEY: $SSH_KEY"
echo "URL: $CSV_URL"
echo "COL: $CSV_COLUMN"
