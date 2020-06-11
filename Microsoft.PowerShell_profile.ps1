function Kali-Build{
	docker build -t kali C:\Users\josea\Documents\kali_docker
}

function Kali-Start{
	$KaliContainers = (docker container ls -a -q -f name=kali | Measure-Object | Select-Object -expand count)
	$IsRunning =  (docker container ls -a -q -f name=kali -f status=running| Measure-Object | Select-Object -expand count)
	if($KaliContainers -eq 0){
		docker run -td --name kali -v C:\Users\josea\Documents\kali_docker\shared:/root/shared --network host --privileged -e TZ=Europe/Madrid -e DISPLAY=192.168.1.66:0.0 kali
	}elseif($IsRunning -eq 0){
		docker container start kali
	} 
}

function Kali-Connect{
	$IsRunning =  (docker container ls -a -q -f name=kali -f status=running| Measure-Object | Select-Object -expand count)
	if($IsRunning -eq 0){
		echo "The container is not running"
	} else{
	docker exec -it kali /bin/zsh
	}
}

function Kali-Stop{
	$IsRunning =  (docker container ls -a -q -f name=kali -f status=running| Measure-Object | Select-Object -expand count)
	$KaliContainers = (docker container ls -a -q -f name=kali | Measure-Object | Select-Object -expand count)
	if($IsRunning -eq 1){
		docker container stop kali
	}elseif($KaliContainers -eq 1){
		docker container rm kali
	}
}

function Kali-Rebuild{
	$ImageExists = (docker image ls kali -q | Measure-Object | Select-Object -expand count)
	Kali-Stop
	if($ImageExists -eq 1){
		docker image stop kali
		docker image rm kali
	} 
	Kali-Build
}

function Hyperv-On{
	bcdedit /set hypervisorlaunchtype auto
}

function Hyperv-Off{
	bcdedit /set hypervisorlaunchtype off
}
