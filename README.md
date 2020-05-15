
# Kali custom docker 🐳

## Setup

 1. Clone the repository: 
	 `git clone https://github.com/itasahobby/kali_docker.git`
 2. Build the container:
	 `docker build -t kali .\` 
3. Create an instance in the background of the container:
	```
	docker run -td --name kali -v .\shared:/root/Documents/shared --network host --privileged -e DISPLAY=192.168.1.66:0.0 kali
	```
	> Notes: 
4.  Connect to the container:
	`docker exec -it kali \bin\zsh`


## Details
  
 - DISPLAY is used to connect to XLaunch on the host machine to be able to run gui applications on the container and display them in the host. 
 
 - In the dockerfile there it also adds [TryHackMe](https://tryhackme.com/) and [HackTheBox](https://www.hackthebox.eu/) openvpn config files. Remember to include them in the same folder as the *Dockerfile* . However If you don't want to include this feature just delete the following lines:
	 ```
	 RUN mkdir -p /root/Documents/vpn/
	ADD htb.ovpn /root/Documents/vpn/htb.ovpn
	ADD thm.ovpn /root/Documents/vpn/thm.ovpn
	 ```
 - Systemd is added so applications like beef that needs to run a server as a service are able to run.
 - The container includes zsh shell. If you don't want to include this feature you can remove the following lines:
	 ```
	 RUN apt-get install -y locales locales-all
	 
	ENV LC_ALL es_ES.UTF-8
	ENV LANG es_ES.UTF-8
	ENV LANGUAGE es_ES.UTF-8

	RUN apt-get install -y zsh &&\
	locale-gen es_ES.UTF-8 &&\
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k

	ADD .zshrc /root/.zshrc
	ADD .p10k.zsh /root/.p10k.zsh
	 ```
	If so remember to delete `.zshrc` and `.p10k.zsh`

## Visual example
![Shell example](https://raw.githubusercontent.com/itasahobby/kali_docker/master/img/Shell.PNG)  
Example connecting to the docker using Windows Terminal and the functions included in the [repo profile](https://github.com/itasahobby/kali_docker/blob/master/Microsoft.PowerShell_profile.ps1).

## Credits
Credits to [Fedeya](https://github.com/Fedeya) as this Docker container is mainly based on his version.
