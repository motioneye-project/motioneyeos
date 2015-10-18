################################################################################
#
# dvblast
#
################################################################################

DVBLAST_VERSION = 3.0
DVBLAST_SOURCE = dvblast-$(DVBLAST_VERSION).tar.bz2
DVBLAST_SITE = https://get.videolan.org/dvblast/$(DVBLAST_VERSION)
DVBLAST_LICENSE = GPLv2+, WTFPL
DVBLAST_LICENSE_FILES = COPYING COPYING.WTFPL
DVBLAST_DEPENDENCIES = bitstream libev

define DVBLAST_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define DVBLAST_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) PREFIX=/usr install
endef

$(eval $(generic-package))
