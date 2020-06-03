FROM centos:7
LABEL maintainer="Doğukan Çağatay <dcagatay@gmail.com>"

# ARG FILE="https://ctf.open.collab.net/sf/frs/do/downloadFile/projects.svnedge/frs.svnedge.5_2_4/frs23789?dl=1"
ARG FILE="https://ctf.open.collab.net/sf/frs/do/downloadFile/projects.svnedge/frs.svnedge.6_0_0/frs24199?dl=1"

ENV PUID "3343"
ENV PGID "3343"
ENV JAVA_HOME "/usr/lib/jvm/jre"
ENV RUN_AS_USER "collabnet"

RUN yum install -y epel-release \
    && yum install -y \
      java-1.8.0-openjdk-headless \
      supervisor \
      sudo \
      wget \
    && yum clean all

RUN wget -q ${FILE} -O /tmp/csvn.tgz && \
    mkdir -p /opt/csvn && \
    tar -xzf /tmp/csvn.tgz -C /opt/csvn --strip=1 && \
    rm -rf /tmp/csvn.tgz

RUN groupadd -g ${PGID} collabnet && \
    useradd -u ${PUID} -g ${PGID} collabnet && \
    chown -R collabnet.collabnet /opt/csvn && \
    cd /opt/csvn && \
    ./bin/csvn install && \
    mkdir -p ./data-initial && \
    cp -r ./data/* ./data-initial

ADD files /

EXPOSE 3343 4434 18080
VOLUME /opt/csvn/data

WORKDIR /opt/csvn
ENTRYPOINT ["/config/bootstrap.sh"]
