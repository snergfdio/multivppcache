#!/usr/bin/env sh
TARGET_DIR=/opt/

if [ "$(uname -m)" = "aarch64" ]
then
    KERNEL_IMG_PACKAGE='linux-image-virtual'
else
    KERNEL_IMG_PACKAGE='linux-image-kvm'
fi

apt-get update
cd ${TARGET_DIR}
KERNEL_IMG_PACKAGE=$(apt-cache depends -i ${KERNEL_IMG_PACKAGE} | grep Depends: | cut -d ' ' -f4)
apt-get -y download ${KERNEL_IMG_PACKAGE}
dpkg --extract ${KERNEL_IMG_PACKAGE}_*.deb ${TARGET_DIR}
cd -
rm -rf /var/lib/apt/lists/*