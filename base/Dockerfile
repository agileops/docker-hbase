FROM openjdk:8-jdk-slim

RUN apt update && \
    apt install -y git maven
RUN git clone -b v4.14.0-HBase-1.4-rc1 --depth 1 https://git-wip-us.apache.org/repos/asf/phoenix.git
RUN cd phoenix && \
    mvn package -DskipTests
RUN mkdir /tmp/phoenix && \
    ls  /phoenix/phoenix-assembly/target/ && \
    cd /tmp/phoenix && \
    ls /tmp/phoenix && \
    tar xvfp  /phoenix/phoenix-assembly/target/phoenix-4.14.0-HBase-1.4.tar.gz --strip-components=1

############################################################

FROM openjdk:8-jre-slim
MAINTAINER Ivan Ermilov <ivan.s.ermilov@gmail.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends net-tools curl netcat python

ENV HBASE_VERSION 1.4.4
ENV HBASE_URL http://www.apache.org/dist/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz
RUN set -x \
    && curl -fSL "$HBASE_URL" -o /tmp/hbase.tar.gz \
    && curl -fSL "$HBASE_URL.asc" -o /tmp/hbase.tar.gz.asc \
    && tar -xvf /tmp/hbase.tar.gz -C /opt/ \
    && rm /tmp/hbase.tar.gz*

RUN ln -s /opt/hbase-$HBASE_VERSION/conf /etc/hbase
RUN mkdir /opt/hbase-$HBASE_VERSION/logs

COPY --from=0 /tmp/phoenix/phoenix-4.14.0-HBase-1.4-server.jar /opt/hbase-$HBASE_VERSION/lib/
COPY --from=0 /tmp/phoenix/phoenix-4.14.0-HBase-1.4-client.jar /opt/hbase-$HBASE_VERSION/lib/

# : SLF4J: Class path contains multiple SLF4J bindings.
# : SLF4J: Found binding in [jar:file:/opt/hbase-1.4.4/lib/phoenix-4.14.0-HBase-1.4-client.jar!/org/slf4j/impl/StaticLoggerBinder.class]
# : SLF4J: Found binding in [jar:file:/opt/hbase-1.4.4/lib/slf4j-log4j12-1.7.10.jar!/org/slf4j/impl/StaticLoggerBinder.class]
# : SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanatio
RUN rm /opt/hbase-1.4.4/lib/slf4j-log4j12-1.7.10.jar
# COPY --from=0 /tmp/phoenix/phoenix-server-4.14.0-HBase-1.4.jar /opt/hbase-$HBASE_VERSION/lib
COPY --from=0 /tmp/phoenix /opt/phoenix
RUN mkdir /hadoop-data

ENV HBASE_PREFIX=/opt/hbase-$HBASE_VERSION
ENV HBASE_CONF_DIR=/etc/hbase

ENV USER=root
ENV PATH $HBASE_PREFIX/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
