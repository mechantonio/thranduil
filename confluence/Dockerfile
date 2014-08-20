# Basics
#
FROM mechatoni/trusty-java7
MAINTAINER Toni Mecha <antonio.mecha@siqme.com>

# Install Confluence

ENV CONFLUENCE_VERSION 5.5.6
RUN curl -Lks http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz -o /root/confluence.tar.gz
RUN /usr/sbin/useradd --create-home --home-dir /opt/confluence --groups atlassian --shell /bin/bash confluence
RUN tar zxf /root/confluence.tar.gz --strip=1 -C /opt/confluence/
RUN chown -R confluence:confluence /opt/atlassian-home
RUN echo "confluence.home = /opt/atlassian-home" > /opt/confluence/confluence/WEB-INF/classes/confluence-init.properties
RUN chown -R confluence:confluence /opt/confluence
RUN mv /opt/confluence/conf/server.xml /opt/confluence/conf/server-backup.xml

ENV CONTEXT_PATH ROOT
ENV JIRA_HOME /opt/atlassian-home

ADD launch.bash /launch

# Launching Confluence
WORKDIR /opt/confluence
VOLUME ["/opt/atlassian-home"]
EXPOSE 8090
USER confluence

CMD ["/launch"]
