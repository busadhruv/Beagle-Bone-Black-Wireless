#!/bin/bash

# Create /dev and some special files under this directory.
mkdir dev
mknod dev/console c 5 1
mknod dev/null c 1 3
mknod dev/zero c 1 5

# Create /lib and /usr/lib, and copy static libraries from the ARM cross compiler toolchain path.
mkdir lib usr/lib
rsync -a /usr/arm-linux-gnueabihf/lib/ ./lib/
mkdir -p ./usr/lib/
rsync -a /usr/arm-linux-gnueabihf/lib/ ./usr/lib/

# Create /proc, /sys, /root directories.
mkdir proc sys root

# Create /etc and additional files inside this directory.
mkdir etc

cat >> etc/inittab <<EOL
null::sysinit:/bin/mount -a
null::sysinit:/bin/hostname -F /etc/hostname
null::respawn:/bin/cttyhack /bin/login root
null::restart:/sbin/reboot
EOL

cat >> etc/fstab <<EOL
proc  /proc proc  defaults  0 0
sysfs /sys  sysfs defaults  0 0
EOL

cat >> etc/hostname <<EOL
embedjournal
EOL

cat >> etc/passwd <<EOL
root::0:0:root:/root:/bin/sh
EOL


