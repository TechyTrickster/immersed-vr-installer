#should work for any debian system with systemctl
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
#start the app image to generate the config files
echo "launching app"
echo "log into / create your immersed account and thene close the app once finished"
./Immersed-x86_64.AppImage
#generate the absolute path to the config file
pathToImmersedConfig="/home/$USER/.ImmersedConf"
pathToImmersedTempConfig="../config/temp.conf"
#install v4l2loopback packages
sudo apt install v4l2loopback-dkms v4l2loopback-utils
#find modprobe
modProbeLocation=$(whereis modprobe -b | sed 's/.*://g' | sed -e 's/^[[:space:]]*//g' | sed -e 's/[ \t].*//g') 
#find rmmod
rmmodLocation=$(whereis rmmod -b | sed 's/.*://g' | sed -e 's/^[[:space:]]*//g' | sed -e 's/[ \t].*//g')
#find a value for an unused video device path
currentMaxVideoDeviceNumber=$(ls /dev | sort | grep "video" | sed 's/video//g' | tail -1)
videoDeviceNumber=$(($currentMaxVideoDeviceNumber+1))
videoDeviceName="/dev/video$videoDeviceNumber"
echo "modprobe location: $modProbeLocation"
echo "rmmod location: $rmmodLocation"
echo "new video device number: $videoDeviceNumber"
echo "script dir: $scriptDir"
echo "calling directory: $ogDir"
echo "path to immersed config: $pathToImmersedConfig"
echo "path to immersed temp config: $pathToImmersedTempConfig"
#configure service file with tool paths
cat ../config/serviceFile.service | sed "s|#modprobeLocation#|$modProbeLocation|g" | sed "s|#rmmodLocation#|$rmmodLocation|g" | sed "s|#videoDevice#|$videoDeviceNumber|g" > ../config/temp.service
cat ../config/temp.service
echo ""
#update immersed config file
cat $pathToImmersedConfig | sed "s|/dev/video.|$videoDeviceName|g" > $pathToImmersedTempConfig
echo ""
cat $pathToImmersedTempConfig
echo ""
cp $pathToImmersedTempConfig $pathToImmersedConfig
#delete temp config file
rm $pathToImmersedTempConfig
#move service file to systemd folder
sudo cp ../config/temp.service /etc/systemd/system/v4l2loopback.service
# #delete temp file
rm ../config/temp.service
#enable new service
sudo systemctl enable v4l2loopback
#start new service
sudo systemctl start v4l2loopback
#change to original directory
cd "$ogDir"
#reboot
#reboot