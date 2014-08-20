#!/bin/sh
DIR=${DEPLOY_DIR:-/maven}
echo "Checking *.war in $DIR"
if [ -d $DIR ]; then
  for i in $DIR/*.war; do
    file=$(basename $i)
    echo "Linking $i --> /opt/tomcat/webapps/$file"
    if [ ! -e /opt/tomcat/webapps/$file ]; then
      ln -s $i /opt/tomcat/webapps/$file
    fi
  done
fi

# Use faster (though more unsecure) random number generator
# export CATALINA_OPTS="$CATALINA_OPTS -Djava.security.egd=file:/dev/./urandom"

export JAVA_OPTS="$JAVA_OPTS -Djavax.net.ssl.keyStore=/usr/alternae/telefonica_spg/mikeystorespotify -Djavax.net.ssl.keyStorePassword=02071974 -Djavax.net.ssl.trustStore=/usr/alternae/telefonica_spg/jssecacerts -Djavax.net.ssl.trustStorePassword=changeit"
# export CATALINA_OPTS="$CATALINA_OPTS "
/opt/tomcat/bin/catalina.sh run