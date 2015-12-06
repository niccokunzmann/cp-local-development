#!/bin/bash

echo -------------------------------------------------------------------------------
echo Install Tools
echo =============
echo See https://github.com/CoderDojo/cp-local-development#install-tools

echo update the packages
sudo apt-get update

echo install postgresql
echo ------------------
echo following the tutorial at
echo   https://help.ubuntu.com/community/PostgreSQL
sudo apt-get -y install postgresql postgresql-contrib
sudo apt-get -y install pgadmin3

sudo -u postgres psql -c "create user platform with superuser password 'QdYx3D5y';"
sudo -u postgres psql -c "create user `whoami` with superuser password 'QdYx3D5y';"

echo install node js
echo ---------------
echo following the tutorial at
echo   http://www.nearform.com/nodecrunch/nodejs-sudo-free/

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

nvm install stable

nvm alias default stable

echo install additional packages
echo ---------------------------
sudo apt-get -y install git

npm install -g grunt

echo -------------------------------------------------------------------------------
echo Code Setup
echo ==========
echo See https://github.com/CoderDojo/cp-local-development#code-setup

default_clone_url="https://github.com/CoderDojo/cp-local-development.git"

echo "Do you have a fork of the community platform?"
echo "  (a) If not, you should create one!"
echo "      1. Visit https://github.com/CoderDojo/cp-local-development"
echo "      2. Log in or sign up"
echo "      3. Click on \"Fork\""
echo "      4. Enter the clone url below. It should look soemthing like"
echo "         $default_clone_url"
echo "  (b) If yes, enter the clone url below. It should look soemthing like"
echo "         $default_clone_url"
echo "      You can find it on the page of your clone on gihub for example."
echo "  (c) Leave the field blank to use the default repository."
echo "         $default_clone_url"
echo "      You can only contribute then if you are a contributer in the CoderDojo organization or"
echo "      if you push your code somewhere else. "
echo "      This option is perfectly fine to just try it out."

read clone_url

directory=cp-local-development
mkdir $directory

if [ "$clone_url" == "" ]
then
  clone_url="$default_clone_url"
fi

git clone $clone_url . || { echo "ERROR: git could not clone $clone_url into $directory"; exit 1; }

cd $directory

npm install

./localdev.js || { echo "ERROR: \"./localdev.js\""; exit 1; }

echo -------------------------------------------------------------------------------
echo localdev init
echo =============
echo see https://github.com/CoderDojo/cp-local-development#localdev-init

./localdev.js init zen || { echo "ERROR: \"./localdev.js init zen\""; exit 1; }

echo -------------------------------------------------------------------------------
echo Running the Platform
echo ====================
echo 
echo Please read https://github.com/CoderDojo/cp-local-development#localdev-run
echo You can now run \"./localdev.js run zen\" and after this \"./localdev.js testdata zen\".





