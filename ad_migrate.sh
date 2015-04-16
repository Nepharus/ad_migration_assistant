##
## This is a program designed to assist in migrating a non- AD user
## on a mac to their AD user. For this to work, we are assuming that
## the machine is already properly named and bound to the AD domain
##
## Created by James Nielsen
##

#!/bin/bash

clear

echo "AD migration assistant v1.5"
echo
echo "This script was designed to assist in migrating a non-AD user"
echo "to AD while keeping their Desktop background, files, and most"
echo "of their preferences."
echo

# Change text color to red
echo "$(tput setaf 1)Warning: Do not run this script while the user you're migrating"
echo "is still logged in. Log them out first and run this script as"
echo "an administrator on their machine.$(tput sgr0)"
echo
echo
echo "Make sure the machine has a wired connection on the school networks"
echo
echo
echo "$(tput setaf 2)Exit this script at any time by hitting $(tput setaf 5)CTRL+C$(tput sgr0)"
echo
echo "Created by courtesy of Team 'FARK"

# Pause to continue
read -n 1 -p "$(tput setaf 4)Press any key to continue...$(tput sgr0)"

clear

# Turn off wireless
echo "Turning off wireless. Please enter in your administrative password"
sudo networksetup -setairportpower en1 off
sleep 3
echo "Done"


# Check if the machine is bound to AD
echo "Checking what domain the machine is bound to for Active Directory"

ADTEST=$(dsconfigad -show | awk '/Active Directory Domain/ {print $5}')
if [ $ADTEST = "alpine.local" ]
then
    echo "You are bound to $(tput setaf 2)alpine.local$(tput sgr0). Moving on."
else
    echo "You are $(tput setaf 1)NOT$(tput sgr0) bound to $(tput setaf 2)alpine.local$(tput sgr0)"
    echo "Please bind the machine before running this script."
    exit
fi

# Check that one of three DC's are reachable
# Specific the DNS (Or IP's) to try
IPs=( "ad1.alpine.local" "ad2.alpine.local" "ad3.alpine.local" )
# Value to return false
found_one=1

# Function for checking for servers
check_servers(){
for ip in ${IPs[*]};
do
# If ping returns true, change found_one to true
	if ping -c 2 -q $ip;
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

# Find out who's running the script
i_am=$(whoami)

# Create an array from the list of users in dscl- excluding users
# with "_", daemon, nobody, and root and $i_am
user_list=($(dscl . -list /Users | grep -v -e "\_" -e daemon -e nobody -e root -e $i_am))

# Tech selection of users
select old_user in "${user_list[@]}"
do
	test -n "$old_user" && break;
	echo ">>> Invalid Selection. Type the number associated with your user."
done
# Show who the old_user is as selected
#echo $old_user

# List selected user's Home Directory and store as old_user_hd
old_user_hd="$(sudo dscl . -read /Users/$old_user | awk '/NFSHomeDirectory/ {print $2}')"
# Show what the Home Directory is from awk above
#echo "$old_user_hd"

# For Home Directories that have spaces, dscl puts these on the second line
# Check if the value pulled from dscl is null or not
if [ -z "$old_user_hd" ];
then
# If null, then grab the second line after
	old_user_hd="$(sudo dscl . -read /Users/$old_user | grep -e "/Users/$old_user_hd")"
# Now, trim the excess leading space
	old_user_hd="$(echo "$old_user_hd" | sed -e 's/^[[:space:]]*//')"
# Show the 'massaged' data
#echo "$old_user_hd"
fi

# Put in the current active directory shortname
echo "Now please enter in the AD username of that user: "
read new_user

# Remove the user using dscl
echo "Removing old user from local directory"
sudo dscl . -delete /Users/${old_user%/}
sleep 2
echo "Done"

# Rename the old username to the new AD username
echo "Rename their home folder to match the AD username"
sudo mv "$old_user_hd" /Users/$new_user
sleep 2
echo "Done"

# Function for the chown check
chown_check(){
# Run command
echo "Attempting to set ownership of their home folder"
echo "This may take a little while- $(tput setaf 2)Please, be patient$(tput sgr0)"
sudo chown -R $new_user:staff /Users/$new_user &>/dev/null
# $? is the value of true or false of last command
chown_is=$?
return $chown_is
}

# Run the function test. If return is NOT 0, do this
if ! chown_check;
then
	echo "Can not set ownership of user's folder."
	echo "Either user was typed incorrectly, or connection to DC lost."
	echo "Please check both and rerrun the program."
	echo "Exiting"
	exit
fi

# Remove Keychain items - doesn't hurt if nothing is there
echo "Removing Keychain items"
sudo rm -rf /Users/$new_user/Library/Keychains/*
sudo rm -rf /Users/$new_user/Library/Keychains/.fl*
sleep 2
echo "Done"

# Remove dropbox file - doesn't hurt if nothing is there
echo "Removing Dropbox associated file"
sudo rm -rf /Users/$new_user/.dropbox
sleep 2
echo "Done"

# Adding new_user to admin group
echo "Adding user to admin goup"
sudo dscl . -append /Groups/admin GroupMembership $new_user
sleep 2
echo "Done"

# Turn wireless back on
sudo networksetup -setairportpower en1 on

# Finished
echo "User migrated!"

#rm -rf /Users/Shared/ad_migrate.*
