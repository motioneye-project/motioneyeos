################################################################################
#
# glog
#
################################################################################

GLOG_VERSION = v0.3.5
GLOG_SITE = $(call github,google,glog,$(GLOG_VERSION))
GLOG_INSTALL_STAGING = YES
GLOG_LICENSE = BSD-3-Clause
GLOG_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_GFLAGS),y)
GLOG_DEPENDENCIES = gflags
endif

# glog can optionally use atomic __sync built-ins. However, its
# configure script only checks for the availability of the 4 bytes
# version, but the code also uses the 1 byte version. While this works
# on most architectures, it does not on architectures that implement
# only the 4 bytes version, such as Microblaze. So if the architecture
# does not implement the 1 byte version, we hint the configure script
# that atomic built-ins should not be used.
ifeq ($(BR2_TOOLCHAIN_HAS_SYNC_1),)
GLOG_CONF_ENV += ac_cv___sync_val_compare_and_swap=no
endif

$(eval $(autotools-package))
