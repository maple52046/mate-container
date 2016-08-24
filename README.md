# Ubuntu Mate Desktop Container

This project can help you build and run a Docker container with Desktop environment (Ubuntu Mate).

## Prerequiresuite

- Install Docker on your machine

## Build image
```
docker build -t ubuntu-mate:14.04 .
```

NOTE: you can change the version of Ubuntu by modify Dockerfiles.

### X11VNC

If you want to use X11VNC to provide a VNC server for this container.
You need to compile and install the beta version of X11VNC (0.9.14).

There is two ways:

#### Method 1: Compile and install X11VNC when execute docker build image

Execute the script file:

```
bash build-x11vnc.sh
```

This script will download the source code of X11VNC 0.9.14 version, 
and compile to become a deb file.

Then, you need to uncomment the following lines in Dockerfiles:

```
COPY x11vnc-0.9.14/x11vnc_0.9.14-1_amd64.deb /tmp/x11vnc_0.9.14-1_amd64.deb
RUN (dpkg -i /tmp/x11vnc_0.9.14-1_amd64.deb || apt-get install -f) && rm /tmp/x11vnc_0.9.14-1_amd64.deb
```

Now, X11VNC will be installed when docker build image.

#### Method 2: Compile and install X11VNC in container

You can copy script `build-x11vnc.sh` into your container, and execute script to build deb file.
Then install it with command `sudo "dpkg -i /tmp/x11vnc_0.9.14-1_amd64.deb || apt-get install -f"`

## Create/Run a container

```
docker run -d --privileged --net default --name mate --hostname mate ubuntu-mate:14.04 /sbin/init
docker exec -it mate useradd -m -s /bin/bash -G sudo myuser
docker exec -it mate passwd myuser
docker exec -d mate service lightdm restart
```

If you have install X11VNC, you can start daemon with docker exec command:

```
docker exec -d mate x11vnc -auth guess -scale 1024x768 -forever
```

NOTE: maybe you will need add `-p 5900:5900` in `docker run ....` to export VNC port.


## Issues

- After your start up lightdm, the tty7 will display the login windows. If your input deveice (mouse, keybord) don't work, you need **unplug the USB socket of device and re-plug it**.
