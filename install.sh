#!/bin/bash

echo "Make a rollback archive directory"
mkdir -p /home/islandora/archive_oct2019_solr_patch

echo "Removing original solr configuration files"
mv /usr/local/solr/collection1/conf/schema.xml /home/islandora/archive_oct2019_solr_patch/schema.xml
mv /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt /home/islandora/archive_oct2019_solr_patch/foxmlToSolr.xslt
mv /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/vtt_solr.xslt /home/islandora/archive_oct2019_solr_patch/vtt_solr.xslt
mv /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/or_transcript_solr.xslt /home/islandora/archive_oct2019_solr_patch/or_transcript_solr.xslt

echo "Copying updated files"
cp -v /home/islandora/compass-solr-config/solr/schema.xml /usr/local/solr/collection1/conf/schema.xml
cp -v /home/islandora/compass-solr-config/fedora/gsearch/foxmlToSolr.xslt /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt
cp -v /home/islandora/compass-solr-config/fedora/gsearch/vtt_solr.xslt /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/vtt_solr.xslt
cp -v /home/islandora/compass-solr-config/fedora/gsearch/or_transcript_solr.xslt /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/or_transcript_solr.xslt

echo "Change permissions on updated files"
chown -v tomcat7:tomcat7 /usr/local/solr/collection1/conf/schema.xml
chown -v tomcat7:tomcat7 /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt
chown -v tomcat7:tomcat7 /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/vtt_solr.xslt
chown -v tomcat7:tomcat7 /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/or_transcript_solr.xslt

echo "Restart Tomcat"
sudo service tomcat7 restart