# Usage

This is meant to be used with a Pi on [Hypriot](http://hypriot.com). Installing it with their tool, [flash](https://github.com/hypriot/flash), is pretty simple.

It has been tested on Hypriot 1.11.

## On host

Add your SSH key to the pi (On OSX? You may need `brew install ssh-copy-id`):

```sh
ssh-copy-id -i ~/.ssh/id_rsa.pub pirate@ip.address
```

Here on, you can do the following remotely.

## Configure Pi

SSH into your pi.

```sh
sudo apt-get clean && \
sudo apt-get upgrade && \
sudo apt-get update -yqq && \
  sudo apt-get install locales-all python3-pip -y && \
  sudo pip3 install setuptools ansible
```

## Ansible

Run the specific role you want. Remember:

- Copy `pi.sample` to `pi` and edit the ip addresses. If you have multiple Pis you want to configure now, you may add them as extra lines
- In the following commands, replace `ip.address` with the Pi's ip address

First, we have to install the things it needs for the recipes to follow:

```sh
ansible-playbook setup.yml -i pi
```

**You may need to restart the Pis after this.** I noticed I was not able to access the internet.

## Playbooks

### TMUX

To install tmux with an opinionated `tmux.conf` (see `roles/tmux/files/tmux.conf`):

```sh
ansible-playbook tmux.yml -i pi
```

### Syncthing Backup Server

To make the Pi a Syncthing backup server:

```sh
ansible-playbook syncthing.yml -i pi
```

- visit port `8384` on your Pi to see the Web GUI
- When adding directories, the data dir can be found at your host's `syncthing_dir`
- ensure `pi` has `[syncthing]` defined with the ip of the pi that will run it

### RVM & Ruby

```sh
ansible-playbook ruby.yml -i pi
```

### Wifi

You want wifi?

```sh
ansible-playbook wifi.yml -i pi --extra-vars="ssid_name=yourssid ssid_password=yourssidpassword"
```

### NoIP (no-ip.com)

**Hasn't been tested yet**

```sh
ansible-playbook noip.yml -i pi --extra-vars="noip_username=yourusername noip_password=yournoippassword"
```

### Disable SSH Password Login

Warning: make sure you are able to log in using a ssh key, or else you won't be able to log in remotely.

```sh
ansible-playbook secure.yml -i pi
```

### Samba share

Here we create a folder on `/media/storage`, with username `pi` with password specified below:

```sh
ansible-playbook nas.yml -i pi --extra-vars="dir=/media/storage/share smbpassword=yoursmbpassword"
```

### NFS (Server)

Copy `roles/nfs_server/files/exports.sample` to `roles/nfs_server/files/exports` and export what you want to be shared to the network.

```sh
ansible-playbook nfs_server.yml -i pi
```

If you have other RPis that will be clients, you can run:

```sh
ansible-playbook nfs_client.yml -i pi
```

To mount on fstab, add something like this:

```
192.168.1.121:/path/on/server   /path/on/local     nfs     noauto,x-systemd.automount,x-systemd.device-timeout=10,timeo=14,hard,intr,noatime    0 0
```

### BitTorrent with Deluge

http://deluge-torrent.org

Docker image: https://github.com/linuxserver/docker-deluge

```sh
ansible-playbook bittorrent.yml -i pi --extra-vars="deluge_config_dir=/media/storage/deluge/config deluge_download_dir=/media/storage/downloads/bittorrent deluge_timezone=Hong\ Kong"
```

Visit `ip.of.pi:8112`. Username and password are `admin`/`deluge`.

It seems that despite setting the `deluge_download_dir`, you still have to go to the preferences and set the download folder to `/downloads`.

## Watch Mount

```sh
ansible-playbook mount.yml -i pi --extra-vars="path=/media/storage"
```

If the mount cannot be detected, it will reboot the system. If you specify a dir that really does not exist, it will keep rebooting. You have 10 cycles (about ~150 seconds -- depends on what monit is configured consider a cycle) to change it before it reboots again.

# Others

## USB Auto Mount

It seems that using systemd to mount the USB caused me less boot issues. The old way of using autofs caused issues where the Pi would get stuck at boot.

See [this](http://serverfault.com/a/804212/63376) for instructions.

Find out where in `/dev/sd*` your disk is (probably `/dev/sda1`):

```sh
sudo fdisk -l
```

You should create the directory where you want it to be mounted: `sudo mkdir /media/storage`

You'll add something like this to `/etc/fstab`:

```
/dev/sda1 /media/storage auto noauto,x-systemd.automount 0 0
```

## Format disk

If you need format the drive, see [this](http://superuser.com/questions/643765/creating-ext4-partition-from-console).
