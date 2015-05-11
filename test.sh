#!/bin/bash

# Color variables
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
RESET=$(tput sgr0)
PINK=$(tput setaf 5)
BLUE=$(tput setaf 4)

mainInt=$(networksetup -listnetworkserviceorder | awk -F'\\) ' '/\(1\)/ {print $2}')

networksetup -ordernetworkservices "$mainInt"
