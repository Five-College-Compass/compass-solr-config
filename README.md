# Compass solr configuration files

In order to manage the solr configuration files for all three compass servers in a centralized way, we are putting them into separate location where we can version control them, and using symlinks to make them available in the various locations that they are needed.

## Installation instructions:

- Git clone this repository to /home/islandora on the server (dev, staging, production), and then move it into the `/opt` directory:
```
cd /home/islandora
git clone https://github.com/Five-College-Compass/compass-solr-config.git
sudo mv compass-solr-config /opt/
sudo chown -Rv tomcat7:tomcat7 /opt/compass-solr-config
```
- Run the backup script as the root user, which simply backs up the original configuration files to a safe location:
```
sudo sh /opt/compass-solr-config/backup.sh
```

## Updating the solr config files:
Do this each time the solr config repo has updates that you need to deploy on this server.
- Run the update script as the root user:
```
sudo sh /opt/compass-solr-config/update.sh
```
