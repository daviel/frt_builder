#!/bin/bash

if [ "$#" -lt 2 ] || [ "$1" == "help" ]
then
	echo "- - - Usage - - -"
	echo "Use the first parameter to specifiy the godot version you want to build"
	echo "Options: master, 3.4, 3.3, 3.2, 3.1, 3.0, 2.1"
	echo ""
	echo "Use the second parameter to specifiy the Raspberry-Pi model you want to build for"
	echo "Options: 0, 1, 2, 3"
	echo ""
	echo "example building godot 3.1 for Pi-2:"
	echo "./build.sh 3.1 2"
	exit
fi

START_TIME=`date +%s`

echo "- - - - - - - - - - - - - - - -"
echo "- - - Building godot v.$1 for Pi-$2 - - -"
echo "- - - - - - - - - - - - - - - -"

apt install qemu-user-static debootstrap git -y
debootstrap --no-check-gpg --foreign --arch=armhf buster ./raspbian http://archive.raspbian.org/raspbian
cp /usr/bin/qemu-arm-static ./raspbian/usr/bin

# configure chroot environment
cp ./config.sh ./raspbian/root/
chroot ./raspbian /root/config.sh


if [ "$1" == "master" ] || [ "$1" == "3.4" ] || [ "$1" == "3.3" ] || [ "$1" == "3.2" ] || [ "$1" == "3.1" ] || [ "$1" == "3.0" ] || [ "$1" == "2.1" ]
then
	echo ""
	echo "- - - Cloning Repositorys - - -"
	echo ""

	# check if target dir exists; just pull commits rather than full clone
	if [ -d "./raspbian/godot-$1" ]; then
		chroot ./raspbian/ /bin/bash -c "cd /godot-$1 && git pull"
	else
		chroot ./raspbian git clone https://github.com/godotengine/godot -b $1 godot-$1
	fi

	if [ -d "./raspbian/godot-$1/platform/frt" ]; then
		chroot ./raspbian/ /bin/bash -c "cd /godot-$1/platform/frt && git pull"
	else
		chroot ./raspbian git clone https://github.com/efornara/frt godot-$1/platform/frt
	fi
else
	echo ""
	echo "- - - No valid Godot-version specified - - -"
	echo ""
	exit
fi



if [ "$2" -ge "0" ] && [ "$2" -le "3" ]
then
	echo ""
	echo "- - - Building for Pi-$2 - - -"
	echo ""

	chroot ./raspbian/ /bin/bash -c "cd /godot-$1 && scons platform=frt target=release frt_arch=pi$2 module_webm_enabled=no builtin_freetype=yes tools=no -j $(nproc)"

	mkdir bin

	echo ""
	echo "- - - Building done for Pi-$2. Copying to ./bin/ - - -"
	echo ""
	cp ./raspbian/godot-$1/bin/* ./bin/
	chmod 777 bin -R
else
	echo ""
	echo "- - - No valid PI-model specified - - -"
	echo ""
	exit
fi


STOP_TIME=`date +%s`
RUNTIME=$((STOP_TIME-START_TIME))

echo "- - - - - - - - - - - - - - - -"
echo "- - - Godot v.$1 for Pi-$2 - - -"
echo "- - - Time: $RUNTIME s - - -"
echo "- - - - - - - - - - - - - - - -"
