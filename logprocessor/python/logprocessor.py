"""Log parser in python3."""

# IMPORTS #
import sys
import getopt
import os
from itertools import islice
# import collections

# sys.argv is way to look at command line options
# print ('Number of arguments:', len(sys.argv), 'arguments.')
# print ('Argument List:', str(sys.argv))


# Separate function is not required
# But part of it might look like this
# Make sure logfile has contents
# def file_is_empty(target_logfile):
#     """Check if logfile has contents."""
#     file_length = os.lstat(target_logfile).st_size
#     if file_length == 0:
#         print(target_logfile, " is empty")
#         sys.exit()
#     else:
#         print(target_logfile, " is not empty")


def logfile_length(target_logfile):
    """Count the total entries in the logfile."""
    num_lines = sum(1 for line in open(target_logfile))
    print(num_lines, "entries in ", target_logfile)


def unique_ips(target_logfile):
    """Unique IP addresses in the logfile."""
    # A list to hold the IPs
    ip_list = []

    # Open the passed in logfile
    # split()[index] are space-separated fields
    # 0 is the first column. The one with the IPs
    with open(target_logfile) as open_logfile:
        for line in open_logfile:
            # Skip if the IP is already in the list
            # Add if the IP is not in the list
            if line.split()[0] in ip_list:
                pass
            else:
                ip_list.append(line.split()[0])
    print(len(ip_list), "IPS found")


def top_ten_ips(target_logfile):
    """List the ten ips that appear the most."""
    ip_list = []
    ip_dict = {}
    seen_ip = set()
    with open(target_logfile) as open_logfile:
        # List of all IP entries
        for line in open_logfile:
            ip_list.append(line.split()[0])
    # A set of uniq IPs
    for current_ip in ip_list:
        if current_ip not in seen_ip:
            seen_ip.add(current_ip)
    # Iterate the set and count occurences in list
    for id, ip_address in enumerate(seen_ip):
        occurences = ip_list.count(ip_address)
        ip_dict[ip_address] = occurences

    # Now sort the IPs by the value (ie the times they appear)
    # Here is the sort
    sorted_ips = sorted(ip_dict.items(), key=lambda x: x[1])

    # Use islice from itertools to get 10 items from the
    # back of the list
    last_ten = list(islice(reversed(sorted_ips), 0, 10))

    # And display the results.
    print()
    print("Top 10 IPs that appear the most")
    print("IP ADDRESS", '\t', "COUNT")
    for ip in last_ten:
        print(ip[0], '\t', ip[1])


def unique_return_codes(target_logfile):
    """Show all different return codes in log."""
    return_list = []
    with open(target_logfile) as open_logfile:
        for line in open_logfile:
            if line.split()[6] in return_list:
                pass
            else:
                return_list.append(line.split()[6])
    print(len(return_list), "Return codes found")


def main(argv):
    """Main method."""
    logfile = ''
    try:
        opts, args = getopt.getopt(argv, "hl:", ["logfile"])
    except getopt.GetoptError:
        print('logparser.py -l <path-to-logfile>')
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print('logparser.py -l <path-to-logfile>')
            sys.exit()
        elif opt in ("-l", "--logfile"):
            logfile = arg
            try:
                if os.stat(logfile).st_size > 0:
                    pass
                    # print(logfile, " has contents")
                else:
                    print(logfile, " is empty or non-existent")
            except OSError:
                print(logfile, " is empty or non-existent")
                sys.exit()

    # print('Logfile: ', logfile)
    # Count the number of lines in the logfile
    logfile_length(logfile)
    unique_ips(logfile)
    top_ten_ips(logfile)
    unique_return_codes(logfile)


if __name__ == "__main__":
    main(sys.argv[1:])
