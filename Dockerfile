FROM jboss/base-jdk:8
MAINTAINER Marco Botega <mabotega@hotmail.com>
ENV WILDFLY_VERSION 18.0.1.Final
ENV WILDFLY_SHA1 ef0372589a0f08c36b15360fe7291721a7e3f7d9
ENV JBOSS_HOME /opt/jboss/wildfly

USER root

RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME} 

ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

EXPOSE 8080
EXPOSE 9990

RUN /opt/jboss/wildfly/bin/add-user.sh admin admin123456 --silent
ADD APP.war /opt/jboss/wildfly/standalone/deployments
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]


