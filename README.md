# Usage

## On host

- Change the inventory IP addresses to your pi address
- Add your SSH key to the pi (On OSX? You may need `brew install ssh-copy-id`):

    ssh-copy-id -i ~/.ssh/id_rsa.pub pi@ip.address

## Configure Pi

In your Pi:

- Run `sudo raspi-config` (does not seem to be a way to do this automatically)
  - Expand Filesystem
  - Reboot
- Prepare the Pi for ansible:

    curl -L https://raw.github.com/KitchenSync/raspberry_configuration/master/install.sh | sudo sh

## Ansible

Run the specific role you want. Remember:

- Copy `pi.sample` to `pi` and edit the ip addresses. If you have multiple Pis you want to configure now, you may add them as extra lines
- In the following commands, replace `ip.address` with the Pi's ip address

First, we have to install the things it needs for the recipes to follow:

    ansible-playbook setup.yml -i pi

## Playbooks

### BitTorrent Sync Backup Server

To make the Pi a BTSync back up server:

    ansible-playbook backup.yml -i pi --extra-vars="btsync_password=mybtsyncpassword"

### RVM & Ruby

Want Ruby and RVM?

    ansible-playbook ruby.yml -i pi

### Wifi

You want wifi?

    ansible-playbook wifi.yml -i pi --extra-vars="ssid_name=yourssid ssid_password=yourssidpassword"

### NoIP

Want to install NoIP (no-ip.com)?

    ansible-playbook noip.yml -i pi --extra-vars="noip_username=yourusername noip_password=yournoippassword"

### Electrum

Want electrum?

    ansible-playbook electrum.yml -i pi

### Disable SSH login

Want to disable SSH login? Warning: make sure you are able to log in using a ssh key, or else you won't be able to log in remotely.

    ansible-playbook secure.yml -i pi

### Samba share

Want network attached storage? Here we create a folder on `/media/storage`, with username `pi` with password specified below:

    ansible-playbook nfs.yml -i --extra-vars="dir=/media/storage/share smbpassword=yoursmbpassword"

### BitTorrent with Deluge

Want a [deluge](http://deluge-torrent.org) bittorrent server?

    ansible-playbook bittorrent.yml -i pi --extra-vars="deluge_username=delugeusername deluge_password=delugepassword download_location=/media/storage/downloads/bittorrent"

In the specified download location, you should set the following in your deluge thin client:

- downloading
- completed
- watch
- torrent-backups

As shown in [this page's](http://www.howtogeek.com/142044/how-to-turn-a-raspberry-pi-into-an-always-on-bittorrent-box/) "Configuring Your Download Location" section.

# Others

## USB Auto Mount

_Instructions from [here](http://kwilson.me.uk/blog/force-your-raspberry-pi-to-mount-an-external-usb-drive-every-time-it-starts-up/)_

Find out where in `/dev/sd*` your disk is (probably `/dev/sda1`):

    sudo fdisk -l

You should create the directory where you want it to be mounted: `sudo mkdir /media/storage`

## Format disk

If you need format the drive, see [this](http://superuser.com/questions/643765/creating-ext4-partition-from-console).
