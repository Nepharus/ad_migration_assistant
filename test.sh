#!/bin/bash
# Run a check that the DNS server is reachable

IPs=( "ad1.alpine.local"  "ad2.alpine.local"  "ad3.alpine.local"  )

for ip in ${IPs[*]}; do
    if ping -c 2 -q $ip &> /dev/null ; then
        echo found $ip up and running. 
        exit 0
    fi
done 
echo Armaggedon. None of these servers exist anymore.
echo Try again later after having recreated world.