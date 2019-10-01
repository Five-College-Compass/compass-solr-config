#!/bin/bash

echo "Make a rollback archive directory"
mkdir -p /home/islandora/archive_oct2019_solr_patch

echo "Removing original solr configuration files"
mv /usr/local/solr/collection1/conf/schema.xml /home/islandora/archive_oct2019_solr_patch/schema.xml
mv /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt /home/islandora/archive_oct2019_solr_patch/foxmlToSolr.xslt
mv /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms /home/islandora/archive_oct2019_solr_patch/islandora_transforms

echo "Linking updated files"
ln -s /opt/compass-solr-config/solr/schema.xml /usr/local/solr/collection1/conf/schema.xml
ln -s /opt/compass-solr-config/fedora/gsearch/islandora_transforms /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms
# GSearch does not like foxmlToSolr.xslt to be a soft link, so we create a hard link instead.
ln /opt/compass-solr-config/fedora/gsearch/foxmlToSolr.xslt /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt

echo "Change permissions on updated files"
chown -h tomcat7:tomcat7 /usr/local/solr/collection1/conf/schema.xml
chown -h tomcat7:tomcat7 /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt
chown -h tomcat7:tomcat7 /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms
chown -Rv tomcat7:tomcat7 /opt/compass-solr-config