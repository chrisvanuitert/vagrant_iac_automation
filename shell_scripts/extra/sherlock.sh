# =============================================================================================================
# DESCRIPTION
# =============================================================================================================

# Sherlock is an open-source Python tool that hunts down social media accounts and related public profiles by
# username across hundreds of websites (forums, social networks, developer sites, marketplaces, etc.). Give it
# a username and it queries each platform’s expected profile URL and reports whether an account exists,
# returning discovered profile URLs and (where available) basic metadata. Sherlock is widely used for OSINT,
# reconnaissance, brand/username monitoring, and account-visibility checks. 

# =============================================================================================================
# INSTALL SHERLOCK
# =============================================================================================================

# UPDATE PACKAGE REPOSITORY 
sudo apt update

# RETURN TO HOME DIRECTORY
cd ~

# CLONE SHERLOCK REPOSITORY
git clone https://github.com/sherlock-project/sherlock.git

# GO TO FOLDER
cd sherlock

# MAKE VIRTUAL ENVIRONMENT
pyenv virtualenv 3.12.6 sherlock-env

# ACTIVATE VIRTUAL ENVIRONMENT
pyenv activate sherlock-env

# UPGRADE PIP TO LATEST VERSION
pip install --upgrade pip

# INSTALL REQUIREMENTS IN ENVIRONMENT
pip install .

# =============================================================================================================
# COMMANDS SHERLOCK
# =============================================================================================================

# SEARCH USERNAME
sherlock name