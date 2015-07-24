FROM ubuntu:trusty
MAINTAINER Omar Padron "omar.padron@kitware.com"

USER root

ENV DEBIAN_FRONTEND noninteractive

ENV HADOOP_VERSION 2.7.1
ENV HADOOP_PREFIX /opt/hadoop
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV HADOOP_URL_ROOT http://archive.apache.org/dist/hadoop/core/
ENV HADOOP_TAR_FILE hadoop-$HADOOP_VERSION.tar.gz
ENV HADOOP_DOWNLOAD_URL \
    $HADOOP_URL_ROOT/hadoop-$HADOOP_VERSION/$HADOOP_TAR_FILE

ENV PATH $PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

RUN apt-get update             && \
    apt-get install -yqq          \
        apt-utils                 \
        openjdk-7-jre-headless    \
        openssh-client            \
        openssh-server            \
        rsync                     \
        sudo                      \
        tar                       \
        wget                   && \
    apt-get clean

RUN wget $HADOOP_DOWNLOAD_URL                                      && \
    tar -zxf $HADOOP_TAR_FILE                                      && \
    rm $HADOOP_TAR_FILE                                            && \
    mkdir -p "$( dirname "$HADOOP_PREFIX" )"                       && \
    mv "$( basename "$HADOOP_TAR_FILE" '.tar.gz' )" $HADOOP_PREFIX && \
    mkdir -p $HADOOP_PREFIX/logs

VOLUME /shared

COPY conf/core-site.xml   $HADOOP_CONF_DIR/core-site.xml
COPY conf/hdfs-site.xml   $HADOOP_CONF_DIR/hdfs-site.xml
COPY conf/mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml
COPY conf/yarn-site.xml   $HADOOP_CONF_DIR/yarn-site.xml

COPY scripts/format-hdfs         /format-hdfs
COPY scripts/run-datanode        /run-datanode
COPY scripts/run-historyserver   /run-historyserver
COPY scripts/run-namenode        /run-namenode
COPY scripts/run-nodemanager     /run-nodemanager
COPY scripts/run-resourcemanager /run-resourcemanager
COPY scripts/run-webproxy        /run-webproxy

