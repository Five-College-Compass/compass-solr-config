#!/bin/bash

echo "Removing original solr configuration files"
rm /usr/local/solr/collection1/conf/schema.xml
rm /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/RELS-EXT_to_solr.xslt
rm /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt
rm /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/vtt_solr.xslt
rm /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/or_transcript_solr.xslt
echo "Creating symlinks to version controlled solr configuration files"
ln -s /home/islandora/compass-solr-config/solr/schema.xml /usr/local/solr/collection1/conf/schema.xml
ln -s /home/islandora/compass-solr-config/fedora/gsearch/RELS-EXT_to_solr.xslt /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/RELS-EXT_to_solr.xslt
ln -s /home/islandora/compass-solr-config/fedora/gsearch/foxmlToSolr.xslt /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt
ln -s /home/islandora/compass-solr-config/fedora/gsearch/vtt_solr.xslt /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/vtt_solr.xslt
ln -s /home/islandora/compass-solr-config/fedora/gsearch/or_transcript_solr.xslt /var/lib/tomcat7/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/or_transcript_solr.xslt
