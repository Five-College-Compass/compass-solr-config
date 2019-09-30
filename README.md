# Compass solr configuration files

In order to manage the solr configuration files for all three compass servers in a centralized way, we are putting them into separate location where we can version control them, and using symlinks to make them available in the various locations that they are needed.

## Installation instructions:

- Git clone this repository to /home/islandora on the server (dev, staging, production):
```
cd /home/islandora
git clone git@bitbucket.org:commonmedia/compass-solr-config.git
```
- Shut down tomcat
```
sudo service tomcat7 stop
```
- Run the install script:
```
sudo sh /home/islandora/compass-solr-config/install.sh
```
- Restart tomcat
```
sudo service tomcat7 start
```


## Update instructions
- Move to repository location
```
cd /home/islandora/compass-solr-config
```
- Shut down tomcat
```
sudo service tomcat7 stop
```
- Pull the updates to the solr config files:
```
git pull origin master
```
- Restart tomcat
```
sudo service tomcat7 start
```
