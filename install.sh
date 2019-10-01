#!/bin/bash
if ! [ $(id -u) = 0 ]; then
   echo "This script must be run as root. Try adding \"sudo \" when running this script."
   exit 1
fi

if [ ! -d /home/islandora/compass_solr_config_backups ]; then
  echo "/home/islandora/compass_solr_config_backups already exists."
  echo "Double-check that you are not overwriting this backup in error!"
  echo "Consult the README.md file for additional instructions"
  echo "Exiting"
  return 1
  fi


echo "Make a rollback archive directory"
mkdir -p /home/islandora/compass_solr_config_backups

echo "Copying original solr configuration files to /home/islandora/compass_solr_config_backups"
cp /usr/local/solr/collection1/conf/schema.xml /home/islandora/compass_solr_config_backups/schema.xml
cp /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt /home/islandora/compass_solr_config_backups/foxmlToSolr.xslt
cp -R /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms /home/islandora/compass_solr_config_backups/islandora_transforms
chown -R islandora:islandora /home/islandora/compass_solr_config_backups