FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Update Repos and Install Tools 

RUN apt-get -y update && apt-get -y upgrade && \
  apt-get install -y \
  kali-linux-core \
  kali-tools-top10 \
  dirb \
  dirbuster \
  git \
  pciutils \
  beef-xss \
  wfuzz \
  iputils-ping \
  binwalk \
  fcrackzip \
  hashcat \
  nikto \
  net-tools \
  bash-completion \
  python3-pip \
  dos2unix \
  vim

  # Install xsstrike
RUN mkdir -p /opt/xsstrike &&\
  git clone https://github.com/s0md3v/XSStrike.git /opt/xsstrike &&\
  chmod +x /opt/xsstrike/xsstrike.py &&\
  ln -s /opt/xsstrike/xsstrike.py /usr/bin/xsstrike &&\
  xsstrike &&\
  # Install dirsearch
  mkdir -p /opt/dirsearch &&\
  git clone https://github.com/maurosoria/dirsearch.git /opt/dirsearch &&\
  ln -s /opt/dirsearch/dirsearch.py /usr/bin/dirsearch &&\
  # Install chrome
  wget -O /root/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&\
  apt-get install -y /root/chrome.deb &&\
  rm /root/chrome.deb

# Setup zsh

RUN apt-get install -y locales locales-all

ENV LC_ALL es_ES.UTF-8
ENV LANG es_ES.UTF-8
ENV LANGUAGE es_ES.UTF-8

RUN apt-get install -y zsh &&\
  locale-gen es_ES.UTF-8  &&\
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
ADD .zshrc /root/.zshrc
ADD .p10k.zsh /root/.p10k.zsh

# Makes sure they are on linux formatting
RUN dos2unix .p10k.zsh &&\
  dos2unix .zshrc

# Openvpn config files
RUN mkdir -p /root/Documents/vpn/ 
ADD htb.ovpn /root/Documents/vpn/htb.ovpn
ADD thm.ovpn /root/Documents/vpn/thm.ovpn

RUN apt-get autoremove -y && \
  apt-get clean

# Run Systemd

RUN cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*; \
  rm -f /lib/systemd/system/plymouth*; \
  rm -f /lib/systemd/system/systemd-update-utmp*;
RUN systemctl set-default multi-user.target
ENV init /lib/systemd/systemd
VOLUME [ "/sys/fs/cgroup" ]
ENTRYPOINT ["/lib/systemd/systemd"]