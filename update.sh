#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "This script must be run as root. Try adding \"sudo \" when running this script."
   return 1
fi
if [ ! -d /opt/compass-solr-config ]; then
  echo "/opt/compass-solr-config does not exist."
  echo "Consult the README.md file for instructions"
  return 1
  fi

echo "Changing git repository ownership to islandora:islandora so that we can git pull as the islandora user."
echo "This is needed because islandora's public key is configured to pull from the compass-solr-config repository"
chown -R islandora:islandora /opt/compass-solr-config
sudo -u islandora bash -c "git pull"

echo "Shutting down tomcat."
service tomcat7 stop

echo "Removing previous solr schema file"
if test -h /usr/local/solr/collection1/conf/schema.xml; then
  unlink /usr/local/solr/collection1/conf/schema.xml
elif test -f /usr/local/solr/collection1/conf/schema.xml; then
  rm /usr/local/solr/collection1/conf/schema.xml
  fi
echo "Removing previous foxmlToSolr.xslt file"  
if test -h /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt; then
  unlink /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt
elif test -f /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt; then
  rm /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt
  fi
echo "Removing previous islandora_transforms directory"  
if test -h /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms; then
  unlink /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms
elif test -d /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms; then
  rm -rf /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms
  fi

echo "Linking updated files"
ln -s /opt/compass-solr-config/solr/schema.xml /usr/local/solr/collection1/conf/schema.xml
ln -s /opt/compass-solr-config/fedora/gsearch/islandora_transforms /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms
# GSearch does not like foxmlToSolr.xslt to be a soft link, so we create a hard link instead.
ln /opt/compass-solr-config/fedora/gsearch/foxmlToSolr.xslt /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt

echo "Change permissions on updated files"
chown -h tomcat7:tomcat7 /usr/local/solr/collection1/conf/schema.xml
chown -h tomcat7:tomcat7 /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt
chown -h tomcat7:tomcat7 /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms

echo "Changing git repository ownership back to tomcat7:tomcat7"
chown -R tomcat7:tomcat7 /opt/compass-solr-config

echo "Restarting tomcat."
service tomcat7 start