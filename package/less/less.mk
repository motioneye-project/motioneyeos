################################################################################
#
# less
#
################################################################################

LESS_VERSION = 487
LESS_SITE = $(BR2_GNU_MIRROR)/less
LESS_LICENSE = GPL-3.0+
LESS_LICENSE_FILES = COPYING
# Build after busybox, full-blown is better
LESS_DEPENDENCIES = ncurses $(if $(BR2_PACKAGE_BUSYBOX),busybox)

define LESS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/less $(TARGET_DIR)/usr/bin/less
endef

$(eval $(autotools-package))
