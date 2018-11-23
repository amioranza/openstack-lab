#/usr/bin/env bash

echo "Update apt packages cache"
sudo apt-get update
echo "Install python-pip"
sudo apt-get -y install python-pip