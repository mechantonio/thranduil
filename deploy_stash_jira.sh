#!/bin/bash
DOCKER=`whereis docker | cut -d" " -f2`
if [ -z "$DOCKER" ]; then
  echo "$DOCKER binary not found, please install it"
  exit 1
fi
if [ "$($DOCKER run busybox echo 'test')" != "test" ]; then
  SUDO=sudo
  if [ "$($SUDO $DOCKER run busybox echo 'test')" != "test" ]; then
    echo "Could not run $DOCKER"
    exit 1
  fi
fi

# Configure external port to avoid binding problems.
PLSQL_EXTERNAL_PORT=${PLSQL_EXTERNAL_PORT:-5431}
STASH_EXTERNAL_PORT=${STASH_EXTERNAL_PORT:-7990}
STASH_EXTERNAL_PORT2=${STASH_EXTERNAL_PORT2:-7999}
JIRA_EXTERNAL_PORT=${JIRA_EXTERNAL_PORT:-7980}

$SUDO $DOCKER pull zaiste/postgresql
$SUDO $DOCKER run -d --name postgres -p=$PLSQL_EXTERNAL_PORT:5432 zaiste/postgresql
if [ $? != 0 ]; then 
  exit 2
fi

# $SUDO $DOCKER build -t mechatoni/atlassian-base base

cd "$(dirname $0)"
cat initialise_db.sh | $SUDO $DOCKER run --rm -i --link postgres:db zaiste/postgresql bash -

# $SUDO $DOCKER build -t mechatoni/stash stash
STASH_VERSION="$($SUDO $DOCKER run --rm mechatoni/stash sh -c 'echo $STASH_VERSION')"
$SUDO $DOCKER tag mechatoni/stash mechatoni/stash:$STASH_VERSION

# $SUDO $DOCKER run -d --name stash --link postgres:db -p $STASH_EXTERNAL_PORT:7990 -p $STASH_EXTERNAL_PORT2:7999 mechatoni/stash

$SUDO $DOCKER build -t mechatoni/jira jira
JIRA_VERSION="$($SUDO $DOCKER run --rm mechatoni/jira sh -c 'echo $JIRA_VERSION')"
$SUDO $DOCKER tag mechatoni/jira mechatoni/jira:$JIRA_VERSION

$SUDO $DOCKER run -d --name jira --link postgres:db --link stash:stash -p $JIRA_EXTERNAL_PORT:8080 mechatoni/jira

echo "Containers running..."
$SUDO $DOCKER ps

echo "IP Addresses of containers:"
$SUDO $DOCKER inspect -f '{{ .Config.Hostname }} {{ .Config.Image }} {{ .NetworkSettings.IPAddress }}' postgres stash jira
