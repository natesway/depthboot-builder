#!/bin/bash

function extractRootfs {

	case $DISTRO in

		arch)
			# Extract the Arch Bootstrap rootfs to /tmp/arch
			# We need an absolute path (/home/user/thing) instead
			# of a relative path (cd ~; thing) since we won't be in
			# ~/linux-build anymore.
			DISTRO_ROOTFS_ABSOLUTE=$(readlink -f $DISTRO_ROOTFS)
			sudo rm -rf /tmp/arch || true
			sudo mkdir /tmp/arch
			cd /tmp/arch # The -c option doesn't work when using the command below
			sudo tar xvpfz $DISTRO_ROOTFS_ABSOLUTE root.x86_64/ --strip-components=1
			cd ~/linux-build
			;;

		fedora)
			# Make the fedora directory
			# If it fails, remove the directory and try to make it again
			sudo rm -rf fedora &> /dev/null || true
			mkdir fedora
			sudo tar xvpf $DISTRO_ROOTFS -C fedora
			cp fedora/6c00560306a90bf0718a9a003defbc89a0d6441b8ec719a69416eba6a06c3218/layer.tar rootfs.tar
			DISTRO_ROOTFS_ABSOLUTE=$(readlink -f rootfs.tar)
			cd /mnt
			sudo tar --wildcards -xvpf "$DISTRO_ROOTFS_ABSOLUTE" "./*"
			cd ~/linux-build
			;;

		*)
			# Assume any other distro has all the root files in the root of the archive
			# Extract the rootfs to the USB Drive
			sudo tar xvpf $DISTRO_ROOTFS -C /mnt
			;;
			
	esac
	syncStorage
	
}

function extractModules {

	sudo mkdir -p /mnt/lib/modules
	mkdir -p modules || sudo rm -rf modules; sudo mkdir -p modules
	sudo tar xvpf modules.tar.xz -C modules
	sudo cp -rv modules/lib/modules/* /mnt/lib/modules
	syncStorage
	
}