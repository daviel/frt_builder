# frt_builder

This is a bash script which creates a arm-based chroot environment in order to
build godot with frt arch (https://github.com/efornara/frt) for a given raspberry pi model.
This does increase the speed of building the binary and also makes it much easier to build 
the most current versions.

If you want to avoid building the binarys yourself take a look at the releases tab where
precompiled binarys are downloadable.


# Usage

Use the first parameter to specifiy the godot version you want to build

Options: master, 3.2, 3.1, 3.0, 2.1

Use the second parameter to specifiy the Raspberry-Pi model you want to build for

Options: 0, 1, 2, 3

example building godot 3.1 for Pi-2:

./build.sh 3.1 2
