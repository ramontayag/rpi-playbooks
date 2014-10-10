mkdir -p ~/Downloads/btsync
cd ~/Downloads/btsync
wget http://download-new.utorrent.com/endpoint/btsync/os/linux-arm/track/stable
mv stable btsync_arm.tar.gz
tar zxvf btsync_arm.tar.gz
cd ~/Downloads
mkdir -p ~/local
mv btsync ~/local
~/local/btsync/btsync --dump-sample-config > ~/local/btsync/btsync.conf
