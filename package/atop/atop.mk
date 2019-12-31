################################################################################
#
# atop
#
################################################################################

ATOP_VERSION = 2.5.0
ATOP_SITE = http://www.atoptool.nl/download
ATOP_LICENSE = GPL-2.0+
ATOP_LICENSE_FILES = COPYING
ATOP_DEPENDENCIES = ncurses zlib

ATOP_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
ATOP_CFLAGS += -O0
endif

define ATOP_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) CFLAGS="$(ATOP_CFLAGS)" \
		-C $(@D)
endef

define ATOP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/atop $(TARGET_DIR)/usr/bin/atop
endef

$(eval $(generic-package))
