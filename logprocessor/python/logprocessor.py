"""Log parser in python3."""

# IMPORTS #
import sys
import getopt
import os
from itertools import islice
# import collections


class Logfile:
    """Make each log an object."""

    # Initialization
    def __init__(self, logfile_name):
        """Initialize logfile object."""
        self.logfile_name = logfile_name

    def __str__(self):
        """Retrieve the logfile name(str)."""
        return("LOGFILE: {}".format(self.logfile_name))

    def __repr__(self):
        """Representation."""
        return repr("LOGFILE: {}".format(self.logfile_name))

    def logfile_length(self):
        """Count the total entries in the logfile."""
        num_lines = sum(1 for line in open(self.logfile_name))
        return(num_lines)

    def unique_ips(self):
        """Unique IP addresses in the logfile."""
        # A list to hold the IPs
        ip_list = []

        # Open the passed in logfile
        # split()[index] are space-separated fields
        # 0 is the first column. The one with the IPs
        with open(self.logfile_name) as open_logfile:
            for line in open_logfile:
                # Skip if the IP is already in the list
                # Add if the IP is not in the list
                if line.split()[0] in ip_list:
                    pass
                else:
                    ip_list.append(line.split()[0])

        return(len(ip_list))

    def top_ten_ips(self):
        """List the ten ips that appear the most."""
        ip_list = []
        ip_dict = {}
        seen_ip = set()
        with open(self.logfile_name) as open_logfile:
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
        # print()
        # print("Top 10 IPs that appear the most")
        # print("IP ADDRESS", '\t', "COUNT")
        # for ip in last_ten:
        #     print(ip[0], '\t', ip[1])
        return(last_ten)

    def unique_return_codes(self):
        """Show all different return codes in log."""
        return_list = []
        with open(self.logfile_name) as open_logfile:
            for line in open_logfile:
                if line.split()[6] in return_list:
                    pass
                else:
                    return_list.append(line.split()[6])

        return(len(return_list))


def main(argv):
    """Main method."""
    logfile = ''
    # First parse the command line
    try:
        opts, args = getopt.getopt(argv, "hl:", ["logfile"])
    except getopt.GetoptError:
        print('logparser.py -l <path-to-logfile>')
        sys.exit(2)

    for opt, arg in opts:
        # If help is requested
        if opt == '-h':
            print('logparser.py -l <path-to-logfile>')
            sys.exit()
        # If a logfile is given
        elif opt in ("-l", "--logfile"):
            logfile = arg
            # Make sure it is not empty
            # This also checks for existence
            try:
                if os.stat(logfile).st_size > 0:
                    pass
                else:
                    print(logfile, " is empty or non-existent")
            except OSError:
                print(logfile, " is empty or non-existent")
                sys.exit()

    # Create a Logfile object and pass in the given log
    current_logfile = Logfile(logfile)

    # Show the logfile name
    # print(str(current_logfile))
    # print(repr(current_logfile))

    # Lines in the log
    print("Log has {} lines".format(current_logfile.logfile_length()))

    # How many unique IPs
    print("Log has {} unique IPs".format(current_logfile.unique_ips()))

    # Ten IPs that appear the most in the log
    top_ten = current_logfile.top_ten_ips()
    print("IP ADDRESS", '\t', "COUNT")
    for ip in top_ten:
        print(ip[0], '\t', ip[1])

    # Unique HTTP return codes found
    print("{} unique HTTP codes".format(current_logfile.unique_return_codes()))


if __name__ == "__main__":
    main(sys.argv[1:])
