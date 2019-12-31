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
                    print(logfile, " has contents")
                else:
                    print(logfile, " is empty or non-existent")
            except OSError:
                print(logfile, " is empty or non-existent")
                sys.exit()

    print('Logfile: ', logfile)

if __name__ == "__main__":
    main(sys.argv[1:])
