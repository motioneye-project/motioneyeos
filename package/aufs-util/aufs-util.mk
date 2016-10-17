################################################################################
#
# aufs-util
#
################################################################################

# linux-headers
AUFS_UTIL_VERSION = $(call qstrip,$(BR2_PACKAGE_AUFS_UTIL_VERSION))
AUFS_UTIL_SITE = http://git.code.sf.net/p/aufs/aufs-util
AUFS_UTIL_SITE_METHOD = git
AUFS_UTIL_LICENSE = GPLv2
AUFS_UTIL_LICENSE_FILES = COPYING

AUFS_UTIL_DEPENDENCIES = linux

# Building aufs-util requires access to the kernel headers of aufs,
# which are only available in the kernel build directory, which is why
# we add -I$(LINUX_DIR)/include/uapi. These headers have not been
# prepared for usage by userspace, so to workaround this we have to
# defined the "__user" macro as empty.
AUFS_UTIL_HOST_CPPFLAGS = \
	$(HOST_CPPFLAGS) \
	-I$(LINUX_DIR)/include/uapi \
	-D__user=

AUFS_UTIL_CPPFLAGS = \
	$(TARGET_CPPFLAGS) \
	-I$(LINUX_DIR)/include/uapi \
	-D__user=

# rdu64 is supposed to provide the LFS variant of readdir(),
# readdir64(). However, because Buildroot is always LFS-enabled,
# readdir() is always the LFS variant. Drop rdu64 from the build, as
# it causes build failures due to multiple implementations of
# readdir64().
define AUFS_UTIL_REMOVE_RDU64
	$(SED) 's% rdu64.o%%' $(@D)/libau/Makefile
endef

AUFS_UTIL_POST_PATCH_HOOKS += AUFS_UTIL_REMOVE_RDU64

# First, we build the host tools, needed to build the target tools.
define AUFS_UTIL_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) \
		$(HOST_CONFIGURE_OPTS) \
		CPPFLAGS="$(AUFS_UTIL_HOST_CPPFLAGS)" \
		HOSTCC="$(HOSTCC)" HOSTLD="$(HOSTLD)" \
		INSTALL="$(INSTALL)" c2sh c2tmac
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(AUFS_UTIL_CPPFLAGS)" \
		INSTALL="$(INSTALL)" all
endef

define AUFS_UTIL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) INSTALL="$(INSTALL)" DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
