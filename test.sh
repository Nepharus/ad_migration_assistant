#!/bin/bash

# Set ownership of the entire folder to the new user

# If fails, we want to stop the script here.
echo "Setting ownership of their home folder"
echo "This may take a little while- $(tput setaf 2)Please, be patient$(tput sgr0)"
sudo chown -R $new_user:staff /Users/$new_user
sleep 2
echo "Done"

chown_is=1
check_chown(){