ARG TAG=latest
FROM hysds/base:${TAG}

MAINTAINER Gerald Manipon (pymonger) "pymonger@gmail.com"
LABEL description "Base HySDS image for development"

# get org and branch
ARG ORG
ARG BRANCH

# git url to hysds dev puppet module
ENV GIT_URL https://github.com/${ORG}/puppet-hysds_dev/raw/${BRANCH}/install.sh

# add latest repo version to invalidate cache
ADD https://api.github.com/repos/${ORG}/puppet-hysds_dev/git/refs/heads/${BRANCH} version.json

# provision via puppet
RUN set -ex \
 && sudo dnf clean all -y \
 && sudo dnf update -y \
 && sudo curl -skL ${GIT_URL} > /tmp/install.sh \
 && sudo chmod 755 /tmp/install.sh \
 && sudo /tmp/install.sh ${ORG} ${BRANCH} \
 && sudo rm -rf /etc/puppetlabs/code/modules/* /mnt/swapfile \
 && sudo dnf clean all \
 && sudo rm -f /tmp/install.sh \
 && sudo rm -rf /var/cache/dnf
