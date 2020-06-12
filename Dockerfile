FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Update repositories and creates general directories
RUN apt-get -y update && apt-get -y upgrade && \
  mkdir -p /root/Downloads &&\
  mkdir -p /root/Documents &&\
  mkdir -p /root/vpn

# Install pentesting and ctf tools
RUN apt-get install -y \
  kali-linux-core \
  kali-tools-top10 \
  dirb \
  whatweb \
  dirbuster \
  git \
  pciutils \
  beef-xss \
  wfuzz \
  iputils-ping \
  binwalk \
  exploitdb \
  enum4linux \
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
  smbmap \
  pdfcrack && \
  pip3 install stegcracker &&\
  pip3 install usbrip &&\
  # Install impacket
  git clone https://github.com/SecureAuthCorp/impacket.git /root/Downloads/impacket &&\
  pip3 install -r /root/Downloads/impacket/requirements.txt &&\
  cd /root/Downloads/impacket/ &&\
  python3 /root/Downloads/impacket/setup.py install &&\
  sed -i  "s/^#\!.*/#\!\/usr\/bin\/python3/" /root/Downloads/impacket/examples/*.py &&\
  find /root/Downloads/impacket/examples/* | xargs -I {} bash -c 'mv $1 "${1%.*}"' _ {} &&\
  mv /root/Downloads/impacket/examples/* /usr/bin &&\
  rm -fr /root/Downloads/impacket &&\
  # Install hash-id
  mkdir -p /opt/hash-id &&\
  git clone https://github.com/blackploit/hash-identifier.git /opt/hash-id &&\
  echo python3 /opt/hash-id/hash-id.py > /opt/hash-id/hash-id.sh &&\
  chmod u+x /opt/hash-id/hash-id.sh &&\
  chmod u+x /opt/hash-id/hash-id.py &&\
  ln -s /opt/hash-id/hash-id.sh /usr/bin/hash-id &&\
  # Install dirsearch
  mkdir -p /opt/dirsearch &&\
  git clone https://github.com/maurosoria/dirsearch.git /opt/dirsearch &&\
  ln -s /opt/dirsearch/dirsearch.py /usr/bin/dirsearch &&\
  # Install arjun
  mkdir -p /opt/arjun &&\
  git clone https://github.com/s0md3v/Arjun.git /opt/arjun/ &&\
  chmod u+x /opt/arjun/arjun.py &&\
  ln -s /opt/arjun/arjun.py /usr/bin/arjun &&\
  updatedb

# General purpose tools
RUN 
# Ccat
  wget https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz -O /root/Downloads/ccat.tar.gz &&\
  cd /root/Downloads/ &&\
  tar xfz /root/Downloads/ccat.tar.gz &&\
  cp /root/Downloads/linux-amd64-1.1.0/ccat /usr/bin/ &&\
  rm -fr /root/Downloads/ccat.tar.gz /root/Downloads/linux-amd64-1.1.0 &&\
  # Install chrome
  wget -O /root/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&\
  apt-get install -y /root/chrome.deb &&\
  rm /root/chrome.deb &&\
  # Install lsd
  wget https://github.com/Peltoche/lsd/releases/download/0.17.0/lsd-musl_0.17.0_amd64.deb -O /root/Downloads/lsd.deb &&\
  dpkg -i /root/Downloads/lsd.deb &&\
  rm /root/Downloads/lsd.deb

# Setup locales
RUN apt-get install -y locales locales-all
ENV LC_ALL es_ES.UTF-8
ENV LANG es_ES.UTF-8
ENV LANGUAGE es_ES.UTF-8

# Setup zsh
RUN apt-get install -y zsh &&\
  locale-gen es_ES.UTF-8  &&\
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
ADD .zshrc /root/.zshrc
ADD .p10k.zsh /root/.p10k.zsh

# Makes sure they are on linux formatting
RUN dos2unix /root/.p10k.zsh &&\
  dos2unix /root/.zshrc

# Openvpn config files
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