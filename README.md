# Dockerfile for PuppetLabs puppet server

This just wraps things all up in a container for easier hosting. It uses 'puppetserver' from the PuppetLabs PPA.

    docker build -t puppetmaster .

    docker run --restart=always -d -p 8140:8140 \
      -v puppetmaster-conf:/etc/puppetlabs \
      -e WEBHOOK_TOKEN=secrettoken \
      -e GITREPO=https://www.yourgitserver.com/git/repo \
      --name puppetmaster \
      puppetmaster

You will need to populate your <tt>/etc/puppetlabs</tt> volume with your own manifests/modules.
