#!/usr/bin/awk -f

BEGIN {
    FS="[(*)]"
    OFS=","

    sdate = "19-DEC-2019"
    edate = "14-MAR-2020"

    month["JAN"] = "01"
    month["FEB"] = "02"
    month["MAR"] = "03"
    month["APR"] = "04"
    month["MAY"] = "05"
    month["JUN"] = "06"
    month["JUL"] = "07"
    month["AUG"] = "08"
    month["SEP"] = "09"
    month["OCT"] = "10"
    month["NOV"] = "11"
    month["DEC"] = "12"

    split(edate, ed, "-")
    split(sdate, sd, "-")
    sdate = sd[3] month[sd[2]] sd[1]
    edate = ed[3] month[ed[2]] ed[1]

    print "DATE,SID,SERVICE_NAME,PROGRAM,HOST,USER"
}

/establish/ {
    flh = 1
    ldate = substr($1, 1, 11)
    split(ldate, ld, "-")
    ldate = ld[3] month[ld[2]] ld[1]
    if (ldate >= sdate && ldate <= edate) {
        for (i = 1; i <= NF; ++i) {
            if ($i ~ /SID/)          { split($i, a, "="); sid = a[2] }
            if ($i ~ /SERVICE_NAME/) { split($i, a, "="); servicename = a[2] }
            if ($i ~ /PROGRAM/)      { split($i, a, "="); program = a[2] }
            if ($i ~ /HOST/ && flh)  { split($i, a, "="); host = a[2]; flh = 0 }
            if ($i ~ /USER/)         { split($i, a, "="); user = a[2] }
        }
        print substr($1, 1, 20), sid, servicename, program, host, user 
    }
}
