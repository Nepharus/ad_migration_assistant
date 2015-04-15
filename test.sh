#!/bin/bash
# Run a check that the DNS server is reachable

#if ping -c 2 -q ad1.alpine.local &> /dev/null
#then
#	echo "There 1"
#	exit;
#else
#	if ping -c 2 -q ad2.alpine.local &> /dev/null
#	then
#		echo "There 2"
#		exit;
#	else
#		if ping -c 2 -q ad3.alpine.local &> /dev/null
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

cond1=$(ping -c 2 -q ad1.alpine.local.1.111 &> /dev/null)
cond2=$(ping -c 2 -q ad2.alpine.local.2.111 &> /dev/null)

if [ $cond1 || $cond2 ];
then
	echo "One of them is accessible"
else
	echo "Neither are accessible"
fi