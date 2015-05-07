#!/bin/bash

# Color variables
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
RESET=$(tput sgr0)
PINK=$(tput setaf 5)
BLUE=$(tput setaf 4)

# Find out what version OS we're dealing with
#Ver=$(sw_vers -productVersion)
#echo $Ver

Ver="10.9.5"

if [ $Ver != "10.6.8" ];
then
	echo "Not 10.6.8"
else
	echo "10.6.8"
fi
