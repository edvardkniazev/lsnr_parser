#!/usr/bin/awk 

BEGIN {
    FS="[(*)]"
    OFS=","

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

    printf "DECLARE\n"
    printf "    eAlreadyExists exception;\n"
    printf "    pragma exception_init(eAlreadyExists, -00955);\n"
    printf "BEGIN\n"
    printf "    execute immediate \'CREATE TABLE listener_%s (\n", listener_name
    printf "    lsnrdate     VARCHAR2(40),\n"
    printf "    service_name VARCHAR2(40),\n"
    printf "    program      VARCHAR2(255),\n"
    printf "    hostname     VARCHAR2(255),\n"
    printf "    username     VARCHAR2(40)\n"
    printf "    )\n"
    printf "    TABLESPACE users\';\n"
    printf "EXCEPTION WHEN eAlreadyExists THEN\n"
    printf "    NULL;  \n"
    printf "END;\n"

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
        printf "INSERT INTO listener_%s (lsnrdate, sid, service_name, program, hostname, username) VALUES (", listener_name
        printf "TO_DATE(\'%s\', \'DD-MON-YYYY HH24:MI\'), \'%s\', \'%s\', \'%s\', \'%s\', \'%s\');\n", substr($1, 1, 20), sid, servicename, program, host, user 
    }
}
