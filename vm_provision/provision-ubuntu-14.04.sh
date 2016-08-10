#!/usr/bin/env bash

# Intended for Ubuntu 14.04 (Trusty)

# Update Ubuntu
apt-get update

# Adjust timezone to be Phoenix
ln -sf /usr/share/zoneinfo/America/Phoenix /etc/localtime

# Apache
echo "----- Provision: Installing apache..."
apt-get install -y apache2 apache2-utils
echo "ServerName localhost" > "/etc/apache2/conf-available/fqdn.conf"
a2enconf fqdn
a2enmod rewrite
a2dissite 000-default.conf

echo "----- Provision: Setup /var/www to point to /vagrant ..."
rm -rf /var/www
ln -fs /vagrant /var/www

# Apache / Virtual Host Setup
echo "----- Provision: Install Host File..."
cp /vagrant/vm_provision/hostfile /etc/apache2/sites-available/project.conf
a2ensite project.conf

#install nodejs v6.x
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y npm

npm install npm -g


#install mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

#Create a /etc/apt/sources.list.d/mongodb-org-3.2.list file for MongoDB.
echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

#Reload local package database.
sudo apt-get update

#Install the MongoDB packages.
sudo apt-get install -y mongodb-org

#Run MongoDB Community Edition
sudo service mongod start

#install sailsjs
npm install sails -g

# Cleanup
apt-get -y autoremove

# Restart Apache
echo "----- Provision: Restarting Apache..."
service apache2 restart
