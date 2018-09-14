FROM snergster/vpp-ubuntu18
MAINTAINER Ed Kern <ejk@cisco.com>
LABEL Description="VPP ubuntu 18 baseline and docker/ssh" 
LABEL Vendor="cisco.com" 
LABEL Version="1.1"


# Setup the environment
ENV DEBIAN_FRONTEND=noninteractive

ADD files/wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

#docker install
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 

RUN apt-get -q update && \
    apt-get install -y -qq \
        docker-ce \
        tzdata \
        locales \
        && rm -rf /var/lib/apt/lists/*

# Configure locales
RUN locale-gen en_US 


RUN mkdir /var/run/sshd
RUN echo 'root:Csit1234' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


#Need volume for sidecar docker launches
VOLUME /var/lib/docker

#ssh to listen on port 6022 in shim
RUN echo 'Port 6022' >>/etc/ssh/sshd_config
RUN echo 'Port 6023' >>/etc/ssh/sshd_config
ADD files/badkeypub /root/.ssh/authorized_keys
ADD files/sshconfig /root/.ssh/config

#Start sshd by default
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]