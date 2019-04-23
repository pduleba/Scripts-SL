#!/bin/bash
# Remove package
sudo mv /var/lib/dpkg/info/PACKAGE_NAME* /tmp/
sudo dpkg --remove --force-remove-reinstreq PACKAGE_NAME
sudo apt-get remove PACKAGE_NAME
sudo apt-get autoremove && sudo apt-get autoclean