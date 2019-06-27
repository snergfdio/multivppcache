# Copyright (c) 2019 Cisco and/or its affiliates.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM centos:centos7.6.1810

MAINTAINER csit-dev <csit-dev@lists.fd.io>
LABEL Description="CSIT vpp-device CentOS 7.6 baseline image (x86)"
LABEL Version="0.1"

# Setup the environment
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ENV NOTVISIBLE "in users profile"
ENV VPP_PYTHON_PREFIX=/var/cache/vpp/python

# Repository settings
RUN yum install -y centos-release-scl epel-release

# Extended layer
RUN yum install -y \
        # general tools
        bridge-utils \
        cloud-init \
        net-tools \
        openssh-server \
        pciutils \
        rsyslog \
        ssh \
        sudo \
        supervisor \
        tar \
        vim \
        wget \
        python-devel \
        java-*-openjdk-devel \
        openssh-clients \
        # csit requirements
        gcc \
        cmake3 \
        docker-1.13 \
        libpcap-devel \
        libpython-devel-2.7 \
        libpython-devel \
        openjdk-8-jdk-headless \
        python-pip \
        python-devel-2.7 \
        python-virtualenv \
        socat \
        strongswan \
        unzip \
        tcpdump \
        zlib-devel \
        # vpp requirements
        ca-certificates-2018 \
        libapr1 \
        mbedtls \
        mbedtls-devel \
        libnuma1 \
        python-cffi \
        python36-cffi \
        python-enum34

# Configure locales
#RUN localectl set-locale "en_US.UTF-8" \
# && localectl status

# Fix permissions
# RUN chown root:syslog /var/log \
# && chmod 755 /etc/default

# Create directory structure
RUN mkdir -p /tmp/dumps \
 && mkdir -p /var/cache/vpp/python \
 && mkdir -p /var/run/sshd

# CSIT PIP pre-cache
RUN pip install \
        docopt==0.6.2 \
        ecdsa==0.13 \
        enum34==1.1.2 \
        ipaddress==1.0.16 \
        paramiko==1.16.0 \
        pexpect==4.6.0 \
        ptyprocess==0.6.0 \
        pycrypto==2.6.1 \
        pykwalify==1.5.0 \
        pypcap==1.1.5 \
        python-dateutil==2.4.2 \
        PyYAML==3.11 \
        requests==2.9.1 \
        robotframework==2.9.2 \
        scapy==2.3.1 \
        scp==0.10.2 \
        six==1.12.0 \
        dill==0.2.8.2 \
        numpy==1.14.5 \
        scipy==1.1.0

# VPP PIP pre-cache
RUN pip install \
        aenum

# lf java insanity
ADD files/lf-update-java-alternatives /usr/local/bin/lf-update-java-alternatives
RUN chmod 755 /usr/local/bin/lf-update-java-alternatives

# SSH settings
RUN echo 'root:Csit1234' | chpasswd \
 && sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
 && echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

COPY supervisord.conf /etc/supervisord/supervisord.conf

CMD ["sh", "-c", "rm -f /dev/shm/db /dev/shm/global_vm /dev/shm/vpe-api; /usr/bin/supervisord -c /etc/supervisord/supervisord.conf; /usr/sbin/sshd -D"]
