FROM ubuntu:14.04
MAINTAINER KuChenHao <maple52046@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Configure apt repository
RUN sed -i 's/archive.ubuntu.com/free.nchc.org.tw/g' /etc/apt/sources.list
RUN apt-get update

RUN apt-get -y install software-properties-common
RUN apt-add-repository -y ppa:ubuntu-mate-dev/ppa
RUN apt-add-repository -y ppa:ubuntu-mate-dev/trusty-mate
RUN apt-get update

# Setting locale
COPY locale /etc/default/locale

# Configure desktop environment
RUN apt-get -y install ubuntu-mate-core ubuntu-mate-desktop language-pack-zh-hant
COPY xorg.conf /etc/X11/

# Configure timezone
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Taipei /etc/localtime

# Install and configure Chinese input method
RUN apt-get -y install hime hime-data
RUN im-config -n hime

# To avoid warning message of non standard stdin
RUN sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /etc/skel/.profile

# X11VNC server
#COPY x11vnc-0.9.14/x11vnc_0.9.14-1_amd64.deb /tmp/x11vnc_0.9.14-1_amd64.deb
#RUN (dpkg -i /tmp/x11vnc_0.9.14-1_amd64.deb || apt-get install -f) && rm /tmp/x11vnc_0.9.14-1_amd64.deb

# Cleanup system
RUN apt-get clean && apt-get autoclean

CMD ["/sbin/init"]
