################################################################################
#
# ptpd2
#
################################################################################

PTPD2_VERSION = 2.2.2
PTPD2_SITE = http://downloads.sourceforge.net/project/ptpd/ptpd/$(PTPD2_VERSION)
PTPD2_SOURCE = ptpd-$(PTPD2_VERSION).tar.gz
PTPD2_LICENSE = BSD-2c
PTPD2_LICENSE_FILES = COPYRIGHT

define PTPD2_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/src
endef

define PTPD2_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/src/ptpd2 $(TARGET_DIR)/usr/sbin/ptpd2
endef

define PTPD2_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/ptpd2/S65ptpd2 \
		$(TARGET_DIR)/etc/init.d/S65ptpd2
endef

$(eval $(generic-package))
