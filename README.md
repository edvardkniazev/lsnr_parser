# lsnr_parser

This awk script parses the listener.log file and finds the established connections.
The output data is in the format "DATE, SID, SERVICE_NAME, PROGRAM, HOST, USER".
It is intentionally written without the gawk advanced features, so the implementation is straightforward.
To set the date range, edit the sdate and edate variables into the lsnr_parser.awk script.
EXAMPLE:
./lsnr_parser.awk listener.log > report.csv
