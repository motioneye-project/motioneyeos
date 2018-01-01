################################################################################
#
# dvdrw-tools
#
################################################################################

DVDRW_TOOLS_VERSION = 7.1
DVDRW_TOOLS_SOURCE = dvd+rw-tools-$(DVDRW_TOOLS_VERSION).tar.gz
DVDRW_TOOLS_SITE = http://fy.chalmers.se/~appro/linux/DVD+RW/tools
DVDRW_TOOLS_LICENSE = GPL-2.0
DVDRW_TOOLS_LICENSE_FILES = LICENSE
DVDRW_TOOLS_DEPENDENCIES = host-m4

define DVDRW_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

ifeq ($(BR2_PACKAGE_DVDRW_TOOLS_CDRKIT_BACKEND),y)
DVDRW_TOOLS_BACKEND = genisoimage
DVDRW_TOOLS_DEPENDENCIES += cdrkit
else ifeq ($(BR2_PACKAGE_DVDRW_TOOLS_XORRISO_BACKEND),y)
DVDRW_TOOLS_BACKEND = xorrisofs
DVDRW_TOOLS_DEPENDENCIES += xorriso
endif

define DVDRW_TOOLS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/dvd-ram-control $(TARGET_DIR)/usr/bin/dvd-ram-control
	$(INSTALL) -m 0755 -D $(@D)/dvd+rw-booktype $(TARGET_DIR)/usr/bin/dvd+rw-booktype
	$(INSTALL) -m 0755 -D $(@D)/dvd+rw-format $(TARGET_DIR)/usr/bin/dvd+rw-format
	$(INSTALL) -m 0755 -D $(@D)/dvd+rw-mediainfo $(TARGET_DIR)/usr/bin/dvd+rw-mediainfo
	$(INSTALL) -m 0755 -D $(@D)/growisofs $(TARGET_DIR)/usr/bin/growisofs
	ln -s -f $(DVDRW_TOOLS_BACKEND) $(TARGET_DIR)/usr/bin/mkisofs
endef

$(eval $(generic-package))
