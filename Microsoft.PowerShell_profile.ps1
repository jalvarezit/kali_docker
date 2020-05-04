function Kali-Build{
	docker build -t kali D:\Users\josea\Documents\docker\kali_docker\
}

function Kali-Start{
	docker run -td --name kali -v D:\Users\josea\Documents\docker\kali_docker\shared:/root/Documents/shared --network host --privileged -e DISPLAY=192.168.1.66:0.0 kali
}

function Kali-Connect{
	docker exec -it kali /bin/zsh
}

function Kali-Stop{
	docker container stop kali
	docker container rm kali
}

function Kali-Rebuild{
	Kali-Stop
	docker image stop kali
	docker image rm kali
	Kali-Build
}

function Hyperv-On{
	bcdedit /set hypervisorlaunchtype auto
}

function Hyperv-Off{
	bcdedit /set hypervisorlaunchtype off
}
