################################################################################
#
# dstat
#
################################################################################

DSTAT_VERSION = 0.7.3
DSTAT_SITE = $(call github,dagwieers,dstat,$(DSTAT_VERSION))
DSTAT_LICENSE = GPL-2.0
DSTAT_LICENSE_FILES = COPYING

define DSTAT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
