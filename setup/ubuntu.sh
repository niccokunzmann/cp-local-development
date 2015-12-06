#!/bin/bash

echo
echo -------------------------------------------------------------------------------
echo Install Tools
echo =============
echo See https://github.com/CoderDojo/cp-local-development#install-tools
echo 

echo update the packages
sudo apt-get update

echo
echo -------------------------------------------------------------------------------
echo install postgresql
echo ------------------
echo following the tutorial at
echo   https://help.ubuntu.com/community/PostgreSQL
echo

sudo apt-get -y install postgresql postgresql-contrib
sudo apt-get -y install pgadmin3

sudo -u postgres psql -c "create user platform with superuser password 'QdYx3D5y';"
sudo -u postgres psql -c "create user `whoami` with superuser password 'QdYx3D5y';"

echo
echo -------------------------------------------------------------------------------
echo install node js
echo ---------------
echo following the tutorial at
echo   http://www.nearform.com/nodecrunch/nodejs-sudo-free/
echo

while [ "`which node`" != "" ] || [ "`which npm`" != "" ]
do
  if [ "`which node`" != "" ]
  then
    echo "Remove the following node installations:"
    which node
  fi
  if [ "`which npm`" != "" ]
  then
    echo "Remove the following npm installations:"
    which npm
  fi
  echo -n "done? "
  read ____
done

sudo apt-get -y install curl
curl https://raw.githubusercontent.com/creationix/nvm/v0.25.0/install.sh | bash

source ~/.bashrc
source ~/.nvm/nvm.sh

if ! type nvm 1>/dev/null 2>/dev/null
then
  echo "ERROR: nvm not found"
  nvm
  exit 1
fi

nvm install stable

nvm alias default stable

echo 
echo "searching for compatible nvm versions v0.10.*"
nvm_latest_version=`nvm ls-remote | grep -E "(^|\s)v0\.10\." | tail -n1 | grep -E -o "v\S+"`
echo "nvm version to install is $nvm_latest_version"
echo 

nvm install $nvm_latest_version
nvm use $nvm_latest_version
nvm alias default $nvm_latest_version

echo
echo -------------------------------------------------------------------------------
echo install additional packages
echo ---------------------------
echo

sudo apt-get -y install git

npm install -g grunt

echo
echo -------------------------------------------------------------------------------
echo Code Setup
echo ==========
echo See https://github.com/CoderDojo/cp-local-development#code-setup
echo 

default_clone_url="https://github.com/CoderDojo/cp-local-development.git"

echo "Do you have a fork of the community platform?"
echo "  (a) If not, you should create one!"
echo "      1. Visit https://github.com/CoderDojo/cp-local-development"
echo "      2. Log in or sign up"
echo "      3. Click on \"Fork\""
echo "      4. Enter the clone url below. It should look something like"
echo "         $default_clone_url"
echo "  (b) If yes, enter the clone url below. It should look something like"
echo "         $default_clone_url"
echo "      You can find it on the page of your clone on gihub for example."
echo "  (c) Leave the field blank to use the default repository."
echo "         $default_clone_url"
echo "      You can only contribute then if you are a contributer in the CoderDojo organization or"
echo "      if you push your code somewhere else. "
echo "      This option is perfectly fine to just try it out."
echo -n "Enter the repository url (default is \"$default_clone_url\" ):"
read clone_url

directory=cp-local-development

if [ -d "$directory" ]
then
  echo "Directory \"$directory\" already exists. Shall it be deleted?"
  echo -n "delete \"$directory\" (y/N) "
  read delete
  if [ "$delete" == "y" ] || [ "$delete" == "Y" ]
  then
    echo "deleting $directory ..."
    rm -rf $directory
  fi
fi

mkdir -p "$directory"

if [ "$clone_url" == "" ]
then
  clone_url="$default_clone_url"
fi

cd "$directory"

git clone $clone_url . || { echo "ERROR: git could not clone $clone_url into $directory"; exit 1; }

sudo apt-get -y install g++

npm install

./localdev.js || { echo "ERROR: \"./localdev.js\""; exit 1; }

echo
echo -------------------------------------------------------------------------------
echo localdev init
echo =============
echo see https://github.com/CoderDojo/cp-local-development#localdev-init
echo

./localdev.js init zen || { echo "ERROR: \"./localdev.js init zen\""; exit 1; }

echo
echo -------------------------------------------------------------------------------
echo Running the Platform
echo ====================
echo 
echo Please read https://github.com/CoderDojo/cp-local-development#localdev-run
echo You can now run \"./localdev.js run zen\" and after this \"./localdev.js testdata zen\".
echo




