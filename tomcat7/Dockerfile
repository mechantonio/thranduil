# Basics
#
FROM mechatoni/trusty-java7
MAINTAINER Toni Mecha <antonio.mecha@siqme.com>

# Install Tomcat

ENV TOMCAT_VERSION 7.0.55
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle/

RUN wget http://apache.rediris.es/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz

# UNpack
RUN tar xzf /tmp/catalina.tar.gz -C /opt
RUN ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat
RUN rm /tmp/catalina.tar.gz

# Add roles
ADD tomcat-users.xml /opt/apache-tomcat-${TOMCAT_VERSION}/conf/

# Startup script
ADD deploy_run.sh /opt/apache-tomcat-${TOMCAT_VERSION}/bin/

# Remove unneeded apps
RUN rm -rf /opt/tomcat/webapps/examples /opt/tomcat/webapps/docs 


EXPOSE 8080
EXPOSE 8009

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin
ENV DEPLOY_DIR /opt/tomcat/deployable

CMD /opt/tomcat/bin/deploy_run.sh
