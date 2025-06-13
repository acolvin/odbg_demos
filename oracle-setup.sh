#!/bin/bash

## Download client
curl -o ~/ic-basic.zip -O https://download.oracle.com/otn_software/linux/instantclient/2380000/instantclient-basic-linux.x64-23.8.0.25.04.zip
curl -o ~/ic-sqlplus.zip -O https://download.oracle.com/otn_software/linux/instantclient/2380000/instantclient-sqlplus-linux.x64-23.8.0.25.04.zip
curl -o ~/ic-tools.zip -O https://download.oracle.com/otn_software/linux/instantclient/2380000/instantclient-tools-linux.x64-23.8.0.25.04.zip

unzip -oq ~/ic-basic.zip -d ~
unzip -oq ~/ic-sqlplus.zip -d ~ 
unzip -oq ~/ic-tools.zip -d ~ 
mkdir -p ~/instantclient_23_8/network/admin

## Get database connection details and create tnsnames.ora
export region=`curl -s "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google" | cut -d '/' -f 4 | cut -d '-' -f 1,2`
export dbname=`hostname -s | cut -d '-' -f 2`
export db_details=`gcloud oracle-database autonomous-databases describe $dbname --location=$region --format="json(properties.connectionStrings.profiles)" | jq -r '.properties.connectionStrings.profiles[0] | select(.consumerGroup=="HIGH" and .tlsAuthentication=="SERVER") | .value'`
printf "$dbname = " > ~/instantclient_23_8/network/admin/tnsnames.ora
cat <<< "$db_details" >> ~/instantclient_23_8/network/admin/tnsnames.ora

## Create profile for Oracle client
rm -Rf ~/.ora_client.env
touch ~/.ora_client.env
printf 'export ORACLE_HOME=~/instantclient_23_8\n'  >> ~/.ora_client.env
printf 'export PATH=$ORACLE_HOME:$PATH\n'  >> ~/.ora_client.env
printf 'export LD_LIBRARY_PATH=$ORACLE_HOME\n' >> ~/.ora_client.env
printf 'export TNS_ADMIN=$ORACLE_HOME/network/admin\n' >> ~/.ora_client.env

## Add Oracle client information to login profile
printf '. ~/.ora_client.env' >> ~/.profile
