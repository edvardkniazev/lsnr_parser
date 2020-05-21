# lsnr_parser.awk

This awk script parses the listener.log file and finds the established connections.
The output data is in the format "DATE, SID, SERVICE_NAME, PROGRAM, HOST, USER".
It is intentionally written without the gawk advanced features, so the implementation is straightforward.
To set the date range, edit the sdate and edate variables into the lsnr_parser.awk script.
EXAMPLE:
./lsnr_parser.awk listener.log > report.csv


# lsnr_parser.sh

This shell script is designed to facilitate interaction with the awk script,
and the main aim is to generate SQL INSERT operations to add to the database.
EXAMPLE:
./lsnr_parser.sh -s 24-MAR-2020 -e 01-APR-2020 -f listener_sid.log -commit 1000
