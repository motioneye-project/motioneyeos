################################################################################
#
# libpfm4
#
################################################################################

LIBPFM4_VERSION = 4.6.0
LIBPFM4_SOURCE = libpfm-$(LIBPFM4_VERSION).tar.gz
LIBPFM4_SITE = http://downloads.sourceforge.net/project/perfmon2/libpfm4
LIBPFM4_LICENSE = libpfm4 license
LIBPFM4_LICENSE_FILES = COPYING
LIBPFM4_INSTALL_STAGING = YES

LIBPFM4_FLAGS = SYS=Linux ARCH=$(BR2_ARCH) \
	CC="$(TARGET_CC)" LDCONFIG=true \
	CONFIG_PFMLIB_SHARED=$(if $(BR2_STATIC_LIBS),n,y) \
	DBG=

define LIBPFM4_BUILD_CMDS
	$(MAKE) -C $(@D) $(LIBPFM4_FLAGS)
endef

define LIBPFM4_INSTALL_STAGING_CMDS
	make -C $(@D) $(LIBPFM4_FLAGS) PREFIX=$(STAGING_DIR)/usr install
endef

define LIBPFM4_INSTALL_TARGET_CMDS
	make -C $(@D) $(LIBPFM4_FLAGS) PREFIX=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
