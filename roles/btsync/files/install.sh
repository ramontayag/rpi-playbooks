mkdir -p ~/Downloads/btsync
cd ~/Downloads/btsync
wget http://btsync.s3-website-us-east-1.amazonaws.com/btsync_arm.tar.gz
tar zxvf btsync_arm.tar.gz
cd ~/Downloads
mkdir ~/local
mv btsync ~/local
~/local/btsync/btsync --dump-sample-config > ~/local/btsync/btsync.conf
