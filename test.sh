#!/bin/bash
# Run a check that the DNS server is reachable

#if ping -I en0 -c 2 -q ad1.alpine.local &> /dev/null
#then
#	echo "There 1"
#	exit;
#else
#	if ping -I en0 -c 2 -q ad2.alpine.local &> /dev/null
#	then
#		echo "There 2"
#		exit;
#	else
#		if ping -I en0 -c 2 -q ad3.alpine.local &> /dev/null
#		then
#			echo "There 3"
#			exit;
#		else
#			echo "Not there"
#			exit;
#		fi
#	fi
#fi
#exit

cond1=$(ping -c 2 -q localhost &> /dev/null)
cond2=$(ping -c 2 -q localhost &> /dev/null)

if [ $cond1 ] || [ $cond2 ]
then
	echo "Both accessible"
else
	echo "One of them isn't accessible"
fi