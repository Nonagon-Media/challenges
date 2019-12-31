"""Log parser in python3."""

# IMPORTS #
import sys
import getopt
import os

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
    with open(target_logfile) as open_logfile:
        for line in open_logfile:
            if line.split()[0] in ip_list:
                pass
            else:
                ip_list.append(line.split()[0])
    print(len(ip_list), "IPS found")


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


if __name__ == "__main__":
    main(sys.argv[1:])
