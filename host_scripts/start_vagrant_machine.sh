#!/bin/bash

# CREATE CLEAN VAGRANT SANDBOX
cd /path/to/vagrant_project
clear
vagrant destroy -f
clear
vagrant up
clear
vagrant ssh