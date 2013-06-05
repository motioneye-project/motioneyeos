################################################################################
#
# unionfs
#
################################################################################

UNIONFS_VERSION = 0.26
UNIONFS_SITE = http://podgorny.cz/unionfs-fuse/releases
UNIONFS_SOURCE = unionfs-fuse-$(UNIONFS_VERSION).tar.xz
UNIONFS_DEPENDENCIES = libfuse host-pkgconf
UNIONFS_LICENSE = BSD-3c
UNIONFS_LICENSE_FILES = LICENSE

$(eval $(cmake-package))
