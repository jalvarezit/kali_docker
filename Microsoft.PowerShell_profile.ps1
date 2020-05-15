function Kali-Build{
	docker build -t kali \path\to\kali_docker\
}

function Kali-Start{
	docker run -td --name kali -v \path\to\kali_docker\kali_docker\shared:/root/shared --network host --privileged -e DISPLAY=192.168.1.66:0.0 kali
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
