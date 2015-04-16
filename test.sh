#!/bin/bash

# Check that chown will work first
# Specify test user
new_user=monkey

# Function for the check
chown_check(){
# Run command
echo "Attempting to set ownership of their home folder"
echo "This may take a little while- $(tput setaf 2)Please, be patient$(tput sgr0)"
sudo chown -R $new_user:staff /Users/$new_user &>/dev/null
# $? is the value of true or false of last command
chown_is=$?
ls -al /Users/
return $chown_is
}

if ! chown_check;
then
	echo "We can't chown"
	exit
fi