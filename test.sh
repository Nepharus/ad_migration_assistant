#!/bin/bash
IPs=( "ad1.alpine.local" "ad2.alpine.local" "ad3.alpine.local" )
# Value to return false
found_one=1

# Function for checking for servers
check_servers(){
for ip in ${IPs[*]};
do
# If ping returns true, change found_one to true
	if ping -c 2 -q $ip &> /dev/null
	then
		found_one=0
	fi
done 
return $found_one
}

# Check the function is not true
if ! check_servers;
then
	echo "None of the DC's are available. Wire the machine on a school network."
	sudo networksetup -setairportpower en1 on
	exit
fi
