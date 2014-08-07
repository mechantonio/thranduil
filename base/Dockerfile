# Basics
#
FROM ubuntu:14.04
MAINTAINER Toni Mecha <antonio.mecha@siqme.com>

# Make APT non-interactive
ENV DEBIAN_FRONTEND noninteractive

# prevent init scripts from running during install/update
# policy-rc.d (for most scripts)
RUN { \
  echo '#!/bin/sh'; \
  echo 'exit 101'; \
} > /usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d

# initctl (for some pesky upstart scripts)
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl
# see https://github.com/dotcloud/docker/issues/446#issuecomment-16953173

# this forces dpkg not to call sync() after package extraction and speeds up install
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup

# # we don't need an apt cache in a container
RUN { \
  aptGetClean='"rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true";'; \
  echo "DPkg::Post-Invoke { ${aptGetClean} };"; \
  echo "APT::Update::Post-Invoke { ${aptGetClean} };"; \
  echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";'; \
  echo 'Acquire::http {No-Cache=True;};'; \
} > /etc/apt/apt.conf.d/no-cache

# and remove the translations, too
RUN echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/no-languages

## Enable Ubuntu Universe and Multiverse.
RUN sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
RUN sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list

# Upgrade the system to the latest version
RUN apt-get update
RUN apt-get dist-upgrade -y --no-install-recommends
# Install packages needed for this image
RUN apt-get install -y --no-install-recommends apt-transport-https ca-certificates
RUN apt-get install -q -y git-core curl sudo xmlstarlet software-properties-common python-software-properties

# Install Java 7
RUN apt-add-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install oracle-java7-installer -y

# Setup volume handling
RUN /usr/sbin/groupadd atlassian
ADD own-volume.sh /usr/local/bin/own-volume
RUN echo "%atlassian ALL=NOPASSWD: /usr/local/bin/own-volume" >> /etc/sudoers
RUN mkdir -p /opt/atlassian-home

# Add common script functions
ADD common.bash /usr/local/share/atlassian/common.bash
RUN chgrp atlassian /usr/local/share/atlassian/common.bash
RUN chmod g+w /usr/local/share/atlassian/common.bash

# Clean everything up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /build
