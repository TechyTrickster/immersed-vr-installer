#get original directory
ogDir=$(pwd)
#get script directory
scriptDir=$( dirname -- "$( readlink -f -- "$0"; )"; ) #more durable than dirname on its own from: https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script user: phatblat
#cd to script directory
cd "$scriptDir"
#download immersed client
wget https://static.immersed.com/dl/Immersed-x86_64.AppImage
#set client as executable
chmod +x Immersed-x86_64.AppImage
#set icon for client
#?how?
#install v4l2loopback packages
sudo apt install v4l2loopback-dkms v4l2loopback-utils
#find modprobe
modProbeLocation=$(whereis modprobe -b | sed 's/.*://g' | sed -e 's/^[[:space:]]*//g' | sed -e 's/[ \t].*//g')
#find rmmod
rmmodLocation=$(whereis rmmod -b | sed 's/.*://g' | sed -e 's/^[[:space:]]*//g' | sed -e 's/[ \t].*//g')
#configure service file with tool paths
cat ./config/serviceFile.service | sed "s/#modprobe_location#/$modProbeLocation/g" | sed "s/#rmmod_location#/$rmmodLocation/g" | sed "s/#video_device#/$videoDeviceNumber/g" > ./config/temp.service
#move service file to systemd folder
sudo mv ./config/temp.service /etc/systemd/system/v4l2loopback.service
#delete temp file
rm ./config/temp.service
#enable new service
sudo systemctl enable v4l2loopback
#start new service
sudo systemctl start v4l2loopback
#change to original directory
cd "$ogDir"
#reboot
reboot