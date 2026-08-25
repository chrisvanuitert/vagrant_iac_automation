#!/bin/bash

VAGRANT_FOLDER="/path/to/vagrant_project"
PROJECTS_FOLDER="/path/to/project_folder"

# CHOOSE PROJECT
cd "$VAGRANT_FOLDER"
clear
echo ""
echo "Hello, what do you want to work on today?"
echo ""

folders=("$PROJECTS_FOLDER"/*/)
options=("${folders[@]%/}")
options=("${options[@]##*/}")

PS3=$'\n'"Select a folder (1-${#options[@]}): "$'\n'
COLUMNS=1

select opt in "${options[@]}"; do
    if [ "$opt" ]; then
        sed -i "s|shared_folder_1_host_location.*=.*|shared_folder_1_host_location  = \"$PROJECTS_FOLDER/$opt\"|" Vagrantfile
        echo ""
        echo "Switched to $opt"
        break
    else
        echo "Invalid selection."
    fi
done

clear
vagrant destroy -f
clear
vagrant up
clear
vagrant ssh