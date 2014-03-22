# Usage

## On host

- Change the inventory IP addresses to your pi address
- Add your SSH key to the pi (On OSX? You may need `brew install ssh-copy-id`):

    ssh-copy-id pi@ip.address

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

To make the Pi a BTSync back up server:

    ansible-playbook backup.yml -i pi

You want wifi?

    ansible-playbook wifi.yml -i pi --extra-vars="ssid_name=yourssid ssid_password=yourssidpassword"

# Others

## USB Auto Mount

_Instructions from [here](http://kwilson.me.uk/blog/force-your-raspberry-pi-to-mount-an-external-usb-drive-every-time-it-starts-up/)_

Find out where in `/dev/sd*` your disk is (probably `/dev/sda1`):

    sudo fdisk -l

You should create the directory where you want it to be mounted: `sudo mkdir /media/storage`

## Format disk

If you need format the drive, see [this](http://www.ehow.com/how_5853059_format-linux-disk.html). I followed the format portion only, not the mount.
