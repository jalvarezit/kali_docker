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
  exploitdb \
  fcrackzip \
  # Also includes other libraries so hashcat can run using cpu
  hashcat libhwloc-dev ocl-icd-dev ocl-icd-opencl-dev pocl-opencl-icd \
  nikto \
  net-tools \
  bash-completion \
  python3-pip \
  dos2unix \
  vim \
  windows-binaries \ 
  theharvester \
  python3 \
  pdfcrack && \
  pip3 install stegcracker &&\
  pip3 install usbrip

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
  rm /root/chrome.deb &&\
  # Install hash-id
  mkdir -p /opt/hash-id &&\
  git clone https://github.com/blackploit/hash-identifier.git /opt/hash-id &&\
  echo python3 /opt/hash-id/hash-id.py > /opt/hash-id/hash-id.sh &&\
  chmod u+x /opt/hash-id/hash-id.sh &&\
  chmod u+x /opt/hash-id/hash-id.py &&\
  ln -s /opt/hash-id/hash-id.sh /usr/bin/hash-id &&\
  # Install arjun
  mkdir -p /opt/arjun &&\
  git clone https://github.com/s0md3v/Arjun.git /opt/arjun/ &&\
  chmod u+x /opt/arjun/arjun.py &&\
  ln -s /opt/arjun/arjun.py /usr/bin/arjun
  # Install impacket toolkit
  #git clone git clone https://github.com/SecureAuthCorp/impacket /root/impacket &&\
  #pip3 install -r /root/impacket/requirements.txt &&\
  #python3 /root/impacket/setup.py install

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
RUN dos2unix /root/.p10k.zsh &&\
  dos2unix /root/.zshrc

# Openvpn config files
RUN mkdir -p /root/vpn/ 
ADD htb.ovpn /root/vpn/htb.ovpn
ADD thm.ovpn /rootvpn/thm.ovpn

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