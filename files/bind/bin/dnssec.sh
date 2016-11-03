#!/bin/sh

dnssec-keygen -a NSEC3RSASHA1 -b 2048 -n ZONE robkaper.nl
dnssec-keygen -f KSK -a NSEC3RSASHA1 -b 4096 -n ZONE robkaper.nl

for key in `ls Krobkaper.nl*.key`;
	do echo "\$INCLUDE $key">> robkaper.nl.db;
done

dnssec-signzone -A -3 $(head -c 1000 /dev/random | sha1sum | cut -b 1-16) -N INCREMENT -o robkaper.nl -t robkaper.nl.db
