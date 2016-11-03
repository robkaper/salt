#!/bin/sh

OPTS=""
ZONEDIR="/var/cache/bind"
NOW=$(date +%s)

cd /tmp

for ZONEFILE in ${ZONEDIR}/*.db; do
	echo "Checking ${ZONEFILE}..."
	if [ ! -f ${ZONEFILE}.signed ]; then
		echo "Unsigned, --genkeys"
		zonesigner --genkeys ${ZONEFILE} 2>/dev/null
  elif [ ${ZONEFILE}.signed -ot ${ZONEFILE} ]; then
		echo "Signed, update for changes"
		zonesigner ${ZONEFILE} 2>/dev/null
	else
		SIGDATE=$(date +%s -r ${ZONEFILE})
		if [ $(( ${NOW} - ${SIGDATE} )) -gt $(( 86400*14 )) ]; then
      echo "Signed, update (signature older than 14d)"
      zonesigner ${ZONEFILE} 2>/dev/null
		else
	    echo "No action"
    fi
  fi
done
