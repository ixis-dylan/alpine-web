#!/bin/sh

# clone git repo and branch from environmental variables
git clone -b ${GIT_BRANCH} ${GIT_URL} /app

# make default site directory
if [ ! -d "/app/sites/default" ]
then
	mkdir -p /app/sites/default/
fi

# setup symlink for assets
if [ ! -d "/app/sites/default/files" ]
then
    ln -s /assets /app/sites/default/files
fi

# set permissions on assets
chown -Rf apache:apache /assets

echo "*/5     *       *       *       *       cd /app && git pull" >> /etc/crontabs/root

# start crons
crond -b -L /dev/null 2>&1

# start apache server in foreground mode
/usr/sbin/httpd -DFOREGROUND

