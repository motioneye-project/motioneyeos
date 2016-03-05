################################################################################
#
# unionfs
#
################################################################################

UNIONFS_VERSION = 1.0
UNIONFS_SITE = $(call github,rpodgorny,unionfs-fuse,v$(UNIONFS_VERSION))
UNIONFS_PATCH = \
	http://git.alpinelinux.org/cgit/aports/plain/main/unionfs-fuse/0001-include-asm-ioctl.h-for-_IOC_SIZE.patch
UNIONFS_DEPENDENCIES = libfuse host-pkgconf
UNIONFS_LICENSE = BSD-3c
UNIONFS_LICENSE_FILES = LICENSE

$(eval $(cmake-package))
