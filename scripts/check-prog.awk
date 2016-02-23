#!/bin/awk -f
BEGIN {
    # in frame
    header = 7;
    type = 6;
    output = 5;
    action = 4;
    info = 3;
    sp = 2
}
{
    split($4, frame, ":");
    if (frame[header] == "FF" &&
        frame[type] == "FF" &&
        frame[action] == "FF" &&
        frame[info] == "FF") {
            os = $1" " $2" " frame[output];
            o = frame[output];
            order_indexes[o]++;
            orders[o][order_indexes[o]] = $0;
            sp_indexes[frame[sp]]++
            setpoints[frame[sp]][sp_indexes[frame[sp]]] = os;
        }
    if (frame[header] == "FF" &&
        frame[type] == "FF" &&
        frame[action] == "FF" &&
        frame[info] == "FE") {
            o = frame[output];
            if (st_indexes[o] == "" || (status[o][st_indexes[o]][1] != frame[sp])) {
                st_indexes[o]++;
                status[o][st_indexes[o]][0] = $0;
                status[o][st_indexes[o]][1] = frame[sp];
            }
        }
    }
END {
    max_orders = 0;
    total_orders = 0;
    max_status = 0;
    total_status = 0;

    for (o in orders) {
        if (o != "") {
            print "VOIE", o, "NB ORDRES :", order_indexes[o];
            if (order_indexes[o] > max_orders)
                max_orders = order_indexes[o];
            for (f in orders[o]) {
                total_orders++;
                if (f != "")
                    print orders[o][f];
            }
        }
    }
    #for (sp in setpoints) {
    #    if (sp != "") {
    #        print "CONSIGNE", sp, "NB CONSIGNES :", sp_indexes[sp];
    #        for (o in setpoints[sp]) {
    #            if (o != "")
    #                print setpoints[sp][o];
    #        }
    #    }
    #}
    for (o in status) {
        if (o != "") {
            print "VOIE", o, "NB STATUS", st_indexes[o];
            if (st_indexes[o] > max_status)
                max_status = st_indexes[o];
            for (st in status[o]) {
                total_status++;
                if (st != "")
                    print status[o][st][0];
            }
        }
    }

    print ""
    print "NB MAX D'ORDRES ENVOYES PAR UNE VOIE :", max_orders;
    print "NB MAX DE STATUS RECUS PAR UNE VOIE :", max_status;
    print "NB TOTAL D'ORDRES :", total_orders;
    print "NB TOTAL DE STATUS :", total_status;
    print ""

    for (o in orders) {
        if (o != "") {
            if (order_indexes[o] != max_orders || order_indexes[o] != st_indexes[o])
                print "PROBLEME VOIE :", o,
                "  ORDRES :", order_indexes[o],
                "  STATUS :", st_indexes[o];
        }
    }
}
