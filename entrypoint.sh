#!/bin/bash

# If we have credentials for our git repo, put them in place
if [ -f /etc/puppetlabs/.netrc ]; then
	cp -vf /etc/puppetlabs/.netrc /root
fi

# Create a configuration file for the deployfiles script
cat >/etc/puppetmaster.conf <<EOF
export GITREPO=$GITREPO
EOF

# Update and re-build each environment
/usr/local/bin/puppetmaster-deployfiles

exec "$@"

