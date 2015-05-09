mkdir -p ~/Downloads/btsync
cd ~/Downloads/btsync
wget https://download-cdn.getsyncapp.com/stable/linux-arm/BitTorrent-Sync_arm.tar.gz
tar zxvf BitTorrent-Sync_arm.tar.gz
cd ~/Downloads
mkdir -p ~/local
mv btsync ~/local
~/local/btsync/btsync --dump-sample-config > ~/local/btsync/btsync.conf
