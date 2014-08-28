#!/bin/bash

# From the trimmed down blog post, db creation is automated
# ---------------------------------------------------------
# We need to note down the IP address of the container so
# that we can wire it up to Confluence later:
# 
#     sudo docker inspect postgres | grep IPAddress
# 
# Note down the IP Address. To test that PostgreSQL is running you can can
# connect to it easily with (password: docker):
# 
#     psql -h <ip-address-noted> -d docker -U docker -W
# 
# (You may need to install the sql client with: `sudo apt-get install
# postgresql-client`).
# 
# We'll need to setup databases for Confluence, if you want to do it now
# at the `psql` shell type:
# 
#     CREATE ROLE confluencedbuser WITH LOGIN PASSWORD 'confluence' VALID UNTIL 'infinity';
#     CREATE DATABASE confluencedb WITH ENCODING 'UNICODE' TEMPLATE=template0;
# 
# The above creates `confluencedb` database with `confluencedbuser` user and password `confluence`.
# --------------------------------------------------------


# Creates Confluence databases and users

# Get IP Address of postgres container
#PSQL_IP=$(sudo docker inspect postgres | grep IPAddress| cut -d '"' -f4)
PSQL_IP=$DB_PORT_5432_TCP_ADDR
PSQL_PORT=$DB_PORT_5432_TCP_PORT

# Saves password
echo "$PSQL_IP:*:*:docker:docker" > $HOME/.pgpass
chmod 0600 $HOME/.pgpass

echo "
CREATE ROLE confluencedbuser WITH CREATEDB CREATEROLE LOGIN PASSWORD 'alternae1@' VALID UNTIL 'infinity';
CREATE DATABASE confluencedb WITH ENCODING 'UTF8' OWNER=confluencedbuser TEMPLATE=template0;" \
PGPASSWORD="docker" psql -h $PSQL_IP -p $PSQL_PORT -d docker -U docker -w

