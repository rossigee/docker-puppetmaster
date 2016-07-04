# Dockerfile for PuppetLabs puppet server

This just wraps things all up in a container for easier hosting. It uses 'puppetserver' from the PuppetLabs PPA.

  docker build -t rossigee/puppetmaster .

  docker run --restart=always -d -p 8140:8140 \
    -v puppetmaster-conf:/etc/puppetlabs \
    -e WEBHOOK_TOKEN=secrettoken \
    -e GITREPO=https://www.yourgitserver.com/git/repo \
    --name puppetmaster \
    rossigee/puppetmaster

You will need to populate your /etc/puppetlabs volume with your own manifests/modules.

Also, if your git repo requires authentication, you should place a custom '.netrc' file in the root of the 'puppetmaster-conf' volume, which is copied into place on container startup, for the 'git clone' and 'git pull' commands to work.

Finally, you just need to ensure your git repo post-receive hook fires the webhook using a line such as the following:

  curl -s https://puppet.yourdomain.com:8141/?token=secrettoken

It might be an idea to put that URL behind an SSL proxy too.

