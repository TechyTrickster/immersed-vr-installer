# Debian Linux Installer for Immersed VR
This is a complete install script for the Immersed VR productivity application for modern distributions of Debian derived Linux.  

### Requirements
1. your system must run systemctl
2. an internet connection
3. a reasonably standard install of modprobe and rmmod
4. the apt package manager

### Why is this necessary?
Immersed VR on linux does not include out of the box support for its virtual web cam.  It typically takes some work to get it up and running.  This script and service file template helps fully automate the install and configuration process.  It will download and install the immersed vr client, the v4l2loopback packages, and set up the service file and enable with proper links to your system's resources. 

### Note To Immersed VR
If you're interested in shipping this script, just get in touch.  I'll be happy to add the necessary polish and include support for a variety of other Linux based operating systems!


### Inspiration and Basis of Methods
In order to actually create this script, I followed a well put together guide (found here: [original guide](https://richarddecal.com/posts/Immersed-VR-Ubuntu/2024-02-01-immersed-vr-ubuntu.html)) by Richard Decal.  The guide didn't quite work in practice on my machine due to some OS implementation detail differences (for instance our modprobe executables are in different locations).  In order to smooth over those differences, I created some more dynamic bash code to fill in the gaps, along with of course automating the whole process!  So thank you to Richard Decal for putting together such a concise guide!


### Warning and Disclaimer
I have only tested this on one of my machines, so far.  While it did work, and I'm reasonably sure this won't hose *your* machine even if it doesn't, I refuse to make any promise.  Use this script at your own risk, as I make no claim of warrenty or fitness for purpose.