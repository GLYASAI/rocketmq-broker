FROM openjdk:8-jdk-alpine
LABEL maintainer=huangrh@goodrain.com

ARG ROCKETMQ_VERSION=4.3.0
ARG ROCKETMQ_HOME=/export/servers/rocketmq
ARG BASE_URL=http://mirror.bit.edu.cn/apache/rocketmq

RUN apk add --no-cache curl tar bash procps
RUN mkdir -p ${ROCKETMQ_HOME} \
  && curl -fsSL -o /tmp/rocketmq.zip ${BASE_URL}/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip \
  && unzip -o /tmp/rocketmq.zip -d ${ROCKETMQ_HOME} \
  && mv ${ROCKETMQ_HOME}/rocketmq-all*/* ${ROCKETMQ_HOME} \
  && rm -rf ${ROCKETMQ_HOME}/rocketmq-all* \
  && rm -f /tmp/rocketmq.zip \
  && rm -rf ${ROCKETMQ_HOME}/bin/runbroker.sh

EXPOSE 10909 10911

COPY runbroker.sh ${ROCKETMQ_HOME}/bin/runbroker.sh
COPY memset.sh ${ROCKETMQ_HOME}/bin/memset.sh
COPY broker-entrypoint.sh ${ROCKETMQ_HOME}/bin/broker-entrypoint.sh

RUN chmod +x ${ROCKETMQ_HOME}/bin/runbroker.sh \
 && chmod +x ${ROCKETMQ_HOME}/bin/memset.sh \
 && chmod +x ${ROCKETMQ_HOME}/bin/broker-entrypoint.sh
 
WORKDIR ${ROCKETMQ_HOME}/bin

ENTRYPOINT ["./broker-entrypoint.sh"]