FROM ubuntu:xenial
MAINTAINER Ross Golder <ross@golder.org>

# Set terminal to be noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Make sure 'puppet' tool is readily available
ENV PATH=/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Get our sources list up-to-date
RUN sed -i 's/deb-src/# deb-src/' /etc/apt/sources.list
RUN apt-get update && \
    apt-get upgrade -y -f

# Add Puppetlabs apt repo
RUN apt-get install -y -f curl && \
    curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb && \
    dpkg -i puppetlabs-release-pc1-xenial.deb && \
    apt-get update

# Install all the things
RUN apt-get install --no-install-recommends -y supervisor ca-certificates nginx puppetserver puppet-agent librarian-puppet git rsync sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# See http://stackoverflow.com/questions/38645491/vagrant-failing-to-install-puppet#38648519
RUN puppetserver gem install json_pure -v 2.0.1
RUN puppetserver gem install hiera-eyaml hiera-puppet r10k

VOLUME /etc/puppetlabs

COPY /supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV PUPPETSERVER_JAVA_ARGS="-Xms512m -Xmx512m"

# Expose Puppet Master port and webhook port
EXPOSE 8140
EXPOSE 8141

# Handle runtime configuration
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Install scripts
COPY puppetmaster-deployfiles puppetmaster-webhook /usr/local/bin/
RUN chmod 755 /usr/local/bin/puppetmaster-*

# Run Puppet Server and webhook
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
