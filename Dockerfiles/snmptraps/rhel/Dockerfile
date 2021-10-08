FROM registry.access.redhat.com/ubi8/ubi-minimal
MAINTAINER Alexey Pustovalov <alexey.pustovalov@zabbix.com>

ARG MAJOR_VERSION=6.0
ARG RELEASE=
ARG ZBX_VERSION=${MAJOR_VERSION}

ARG ZBX_SOURCES=https://git.zabbix.com/scm/zbx/zabbix.git
ENV ZBX_VERSION=${ZBX_VERSION} ZBX_SOURCES=${ZBX_SOURCES}

ENV TERM=xterm ZBX_VERSION=${ZBX_VERSION} ZBX_SOURCES=${ZBX_SOURCES} \
    MIBDIRS=/usr/share/snmp/mibs:/var/lib/zabbix/mibs MIBS=+ALL \
    ZBX_SNMP_TRAP_DATE_FORMAT=+%Y%m%d.%H%M%S ZBX_SNMP_TRAP_FORMAT=" "

LABEL name="zabbix/zabbix-snmptraps-trunk" \
      maintainer="alexey.pustovalov@zabbix.com" \
      vendor="Zabbix LLC" \
      version="${MAJOR_VERSION}" \
      release="${RELEASE}" \
      summary="Zabbix SNMP traps receiver" \
      description="Zabbix SNMP traps receiver" \
      url="https://www.zabbix.com/" \
      run="docker run --name zabbix-snmptraps --link zabbix-server:zabbix-server -p 162:1162/udp -d registry.connect.redhat.com/zabbix/zabbix-snmptraps-trunk:${ZBX_VERSION}" \
      io.k8s.description="Zabbix SNMP traps receiver" \
      io.k8s.display-name="Zabbix SNMP traps receiver" \
      io.openshift.expose-services="162:1162" \
      io.openshift.tags="zabbix,zabbix-snmp,snmp-traps" \
      org.label-schema.name="zabbix-snmptraps-rhel" \
      org.label-schema.vendor="Zabbix LLC" \
      org.label-schema.url="https://zabbix.com/" \
      org.label-schema.description="Zabbix SNMP traps receiver" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.license="GPL v2.0" \
      org.label-schema.usage="https://www.zabbix.com/documentation/${MAJOR_VERSION}/manual/installation/containers" \
      org.label-schema.version="${ZBX_VERSION}" \
      org.label-schema.vcs-url="${ZBX_SOURCES}" \
      org.label-schema.docker.cmd="docker run --name zabbix-snmptraps --link zabbix-server:zabbix-server -p 162:1162/udp -d registry.connect.redhat.com/zabbix/zabbix-snmptraps-trunk:${ZBX_VERSION}"

STOPSIGNAL SIGTERM

COPY ["licenses", "/licenses"]

RUN set -eux && \
    INSTALL_PKGS="shadow-utils \
            tzdata \
            net-snmp" && \
    microdnf -y --disablerepo="*" --enablerepo="rhel-8-for-x86_64-baseos-rpms" \
        --enablerepo="rhel-8-for-x86_64-appstream-rpms" \
        install --setopt=install_weak_deps=0 --best --nodocs ${INSTALL_PKGS} && \
    groupadd --system --gid 1995 zabbix && \
    useradd \
            --system --comment "Zabbix monitoring system" \
            -g zabbix -G root \
            --uid 1997 \
            --shell /sbin/nologin \
            --home-dir /var/lib/zabbix/ \
        zabbix && \
    mkdir -p /var/lib/zabbix && \
    mkdir -p /var/lib/zabbix/snmptraps && \
    mkdir -p /var/lib/zabbix/mibs && \
    touch /var/lib/net-snmp/snmptrapd.conf && \
    chown --quiet -R zabbix:root /etc/snmp/ /var/lib/zabbix/ /var/tmp/ /var/run/ && \
    chgrp -R 0 /etc/snmp/ /var/lib/zabbix/ /var/tmp/ /var/run/ && \
    chmod -R g=u /etc/snmp/ /var/lib/zabbix/ /var/tmp/ /var/run/ && \
    microdnf -y clean all && \
    rm -rf /var/cache/yum /var/lib/yum/yumdb/* /usr/lib/udev/hwdb.d/* && \
    rm -rf /var/cache/dnf /etc/udev/hwdb.bin /root/.pki

EXPOSE 1162/UDP

WORKDIR /var/lib/zabbix/snmptraps/

VOLUME ["/var/lib/zabbix/snmptraps"]

COPY ["conf/etc/logrotate.d/zabbix_snmptraps", "/etc/logrotate.d/"]
COPY ["conf/etc/snmp/snmptrapd.conf", "/etc/snmp/"]
COPY ["conf/usr/sbin/zabbix_trap_handler.sh", "/usr/sbin/"]

USER 1997

CMD ["/usr/sbin/snmptrapd", "-n", "-C", "-c", "/etc/snmp/snmptrapd.conf", "-Lo", "-A"]