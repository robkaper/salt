#!/bin/sh

OPTS=""
ZONEDIR="/var/cache/bind"
NOW=$(date +%s)

cd /tmp

for ZONEFILE in $(ls ${ZONEDIR}/*.db); do
	ZONE=$(basename ${ZONEFILE} | sed s/\.db//)
	echo "${ZONE}:"
	if [ ! -f ${ZONEFILE}.signed ]; then
		echo "Unsigned, run manually:"
		echo "zonesigner --genkeys -zone ${ZONE} ${ZONEFILE}"
		echo "And add DNSSEC key to WHOIS"
		exit 1
		# zonesigner --genkeys -zone ${ZONE} ${ZONEFILE} 2>/dev/null
  elif [ ${ZONEFILE}.signed -ot ${ZONEFILE} ]; then
		echo "Signed, update for changes"
		zonesigner -zone ${ZONE} ${ZONEFILE} 2>/dev/null
		touch ${ZONEFILE}
	else
		SIGDATE=$(date +%s -r ${ZONEFILE}.signed)
		if [ $(( ${NOW} - ${SIGDATE} )) -gt $(( 86400*14 )) ]; then
      echo "Signed, update (signature older than 14d)"
      zonesigner -zone ${ZONE} ${ZONEFILE} 2>/dev/null
		else
	    echo "No action"
    fi
  fi
	echo
done
