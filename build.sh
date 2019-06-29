#!/bin/bash
#
# This script builds custom debian live images, using live-build.
#
# Consult live-manual for more details:
# https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html

set -e
lb config \
	--distribution stretch \
	--binary-images iso-hybrid \
	"$@"

echo \
	task-danish \
	task-laptop \
	task-ssh-server \
	xorg \
	xinit \
	vim \
	chromium \
	plymouth \
	plymouth-x11 \
	>config/package-lists/my-live.list.chroot

echo \
	live-config \
	live-boot \
	live-config-systemd \
	live-manual \
	live-tools \
	apt \
	wget \
	net-tools \
	pci-utils \
	broadcom-sta-dkms \
	cryptsetup \
	curl \
	dosfstools \
	less \
	lsb-release \
	lshw \
	lvm2 \
	mdadm \
	net-tools \
	openssh-client \
	openssh-server \
	pciutils \
	smartmontools \
	usbutils \
	gstreamer1.0-vaapi \
	i965-va-driver \
	fglrx-modules-dkms \
	fglrx-driver \
	fglrx-control \
	nvidia-kernel-dkms \
	nvidia-glx \
	xserver-xorg-video-nvidia \
	nvidia-settings \
	nvidia-xconfig \
	nvidia-vdpau-driver \
	vdpau-va-driver \
	>config/package-lists/tools.list.chroot

# Link our pretty little hooks.
for hook in hooks/*/*; do
	(cd config/"$(dirname "$hook")" && ln -s ../../../"$hook" ./ || true)
done

# Let there be image.
nohup lb build > buildhulo.txt 2>&1 &
tail -F buildhulo.txt > /var/www/html/log.txt 2>&1 &

# List devices, if lsscsi is available.
#lsscsi 2>/dev/null || true

#echo 'Time to "burn", make sure you use the right drive:'
#echo "  dd if=live-image-amd64.img of=/dev/sdX bs=4096 status=progress"
