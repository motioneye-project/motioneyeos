################################################################################
#
# unionfs
#
################################################################################

UNIONFS_VERSION = 2.0
UNIONFS_SITE = $(call github,rpodgorny,unionfs-fuse,v$(UNIONFS_VERSION))
UNIONFS_DEPENDENCIES = libfuse host-pkgconf
UNIONFS_LICENSE = BSD-3-Clause
UNIONFS_LICENSE_FILES = LICENSE

$(eval $(cmake-package))
