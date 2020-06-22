### Kali custom docker for windows🐳
### Description and context
---
This is a full guide on how to setup a custom kali docker in windows, together with Windows Terminal, Openvpn and XMing. Once the setup is finished, deploying the container takes seconds, contrary to VMs.
This system is highly advizable if you mainly use the terminal.

### User Guide
---
Available commands are:
* Kali-Build (Builds the image, only needs to be done the first time)
* Kali-Rebuild (Rebuilds the image and delets the containers that uses this image)
* Kali-Start (Creates the isntance of the image in the background)
* Kali-Stop (Stops and removes the containers using the image)
* Kali-Connect (Connects the terminal to that instance)

> Both `Kali-Rebuild` and `Kali-Stop` will delete all data inside the existing containers. 
### Setup
---
1. Download the repository either by using `git clone https://github.com/itasahobby/kali_docker.git` or clicking on download.
2. Configure OpenVpn:
    1. Install [OpenVPN Connect](https://openvpn.net/client-connect-vpn-for-windows/)
    2. Include your openvpn configuration files (or remove the default ones) in the Dockerfile:
        ```Dockerfile
        # Openvpn config files
        ADD htb.ovpn /root/vpn/htb.ovpn
        ADD thm.ovpn /rootvpn/thm.ovpn
        ``` 
    3. Copy the configuration files to the same folder as the dockerfile
> This step is optional, if you are not using OpenVpn remember to delete the lines mentioned in the step 2.2 from the Dockerfile 
3. Configure Windows Terminal:
    1. Install [Windows Terminal](https://www.microsoft.com/es-es/p/windows-terminal/9n0dx20hk701#)
    2. Open Windows Terminal and type `notepad $Profile`, then copy the content of _Microsoft.Powershell_profile.ps1_ in there. Alternatively you can paste the file to *C:/Users/**user**/Documents/WindowsPowerShell/*
    3. Open Windows Terminal's settings and copy the content of **settings.json** (it can also be opened with Ctrl + , using default shortcuts). Alternatively you can paste the file to *C:/Users/**user**/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json*
    4. Save the backgrounds to *%LOCALAPPDATA%/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/RoamingState*. Remember that the name of the image must match the **settings.json** parameter mentioned in the previous step. Adittionaly there are some sample background images in the *img* folder inside the repository.
    5. If you are using zsh with the container, you have to install [Powerlevel10k fonts](https://github.com/romkatv/powerlevel10k#manual-font-installation).
4. Setup X11 Server:
    1. Install vcxsrv with `choco install vcxsrv`
    2. Edit `-e DISPLAY=\<your-ip>:0.0` in your Windows Terminal configuration (from step 3.2) replacing \<your-ip> with your actual ip.
    3. Open XLaunch from your Windows menu (default parameters are fine), and you can save the settings to avoid those steps whenever you reboot your pc, instead just opening the file generated.
> This step is optional, if you are not using X11 server edit your Windows Terminal configuration (from step 3.2) and remove `-e DISPLAY=\<your-ip>:0.0` from `Kali-Start` 
5. Run your docker:
    1. Build the image with `Kali-Build` or ` docker build -t kali \path\to\kali_docker\ `
    2. Start a container with `Kali-Start`  or `docker run -td --name kali -v \path\to\kali_docker\kali_docker\shared:/root/shared --network host --privileged -e DISPLAY=<your-ip>:0.0 kali `
    3. Connect to the container with `Kali-Connect` or `docker exec -it kali /bin/zsh`
> Use the second option if you are not using Windows Terminal.

### How to contribute
---
If you want to contribute to the project you can pull requests, add a new issue if you find any problem, or fixing one of the existing ones.

### Código de conducta 
---

Check our code of conduct (here)[https://github.com/itasahobby/kali_docker/blob/master/CODE_OF_CONDUCT.md]

### Author
---
Built by [ITasahobby]() inspired by [Fedeya](https://github.com/Fedeya)'s kali docker.