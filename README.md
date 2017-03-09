# Usage

NOTE: I'm currently moving these playbooks to use Docker whenever possible and wise. See progress in the [hypriot_compat](https://github.com/ramontayag/rpi-playbooks/tree/hypriot_compat) branch.

It looks like the new version of Raspbian do not have SSH enabled. This is probably for the better - people won't accidentally leave the port open with the default password `raspberry`. However, it makes it a little harder to get your Pi setup because you'll need a monitor and a keyboard.

- Before we start, boot up your Pi, and in `sudo raspi-config`, navigate to Advanced Options and enable SSH.
- While you're there, we might as well expand the filesystem. In the main menu, expand the filesystem.

## On host

- Change the inventory IP addresses to your pi address
- Add your SSH key to the pi (On OSX? You may need `brew install ssh-copy-id`):

```sh
ssh-copy-id -i ~/.ssh/id_rsa.pub pi@ip.address
```

Here on, you can do the following remotely.

## Configure Pi

SSH into your pi.

```sh
sudo apt-get update
sudo apt-get install python3.4-minimal python3.4 python-crypto python-markupsafe python-jinja2 python-paramiko python-pkg-resources python-setuptools python-pip python-yaml -y
sudo pip install ansible
```

## Ansible

Run the specific role you want. Remember:

- Copy `pi.sample` to `pi` and edit the ip addresses. If you have multiple Pis you want to configure now, you may add them as extra lines
- In the following commands, replace `ip.address` with the Pi's ip address

First, we have to install the things it needs for the recipes to follow:

```sh
ansible-playbook setup.yml -i pi
```

## Playbooks

### BitTorrent Sync Backup Server

To make the Pi a BTSync back up server:

```sh
ansible-playbook backup.yml -i pi --extra-vars="btsync_password=mybtsyncpassword"
```

### Docker

To be able to run Docker:

```sh
ansible-playbook docker.yml -i pi
```

### Syncthing Backup Server

To make the Pi a Syncthing backup server:

```sh
ansible-playbook syncthing.yml -i pi
```

Visit port `8889` on your Pi to see the Web GUI.

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

### Electrum

```sh
ansible-playbook electrum.yml -i pi
```

### Disable SSH login

Warning: make sure you are able to log in using a ssh key, or else you won't be able to log in remotely.

```sh
ansible-playbook secure.yml -i pi
```

### Samba share

Here we create a folder on `/media/storage`, with username `pi` with password specified below:

```sh
ansible-playbook nas.yml -i pi --extra-vars="dir=/media/storage/share smbpassword=yoursmbpassword"
```

### BitTorrent with Deluge

http://deluge-torrent.org

```sh
ansible-playbook bittorrent.yml -i pi --extra-vars="deluge_username=delugeusername deluge_password=delugepassword download_location=/media/storage/downloads/bittorrent"
```

In the specified download location, you should set the following in your deluge thin client:

- downloading
- completed
- watch
- torrent-backups

As shown in [this page's](http://www.howtogeek.com/142044/how-to-turn-a-raspberry-pi-into-an-always-on-bittorrent-box/) "Configuring Your Download Location" section.

## Watch Mount

```sh
ansible-playbook mount.yml -i pi --extra-vars="path=/media/storage"
```

If the mount cannot be detected, it will reboot the system. If you specify a dir that really does not exist, it will keep rebooting. You have 10 cycles (about ~150 seconds -- depends on what monit is configured consider a cycle) to change it before it reboots again.

# Others

## USB Auto Mount

_Instructions from [here](http://kwilson.me.uk/blog/force-your-raspberry-pi-to-mount-an-external-usb-drive-every-time-it-starts-up/)_

Find out where in `/dev/sd*` your disk is (probably `/dev/sda1`):

```sh
sudo fdisk -l
```

You should create the directory where you want it to be mounted: `sudo mkdir /media/storage`

## Format disk

If you need format the drive, see [this](http://superuser.com/questions/643765/creating-ext4-partition-from-console).
