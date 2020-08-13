################################################################################
#
# ptpd
#
################################################################################

PTPD_VERSION = 1.1.0
PTPD_SITE = http://downloads.sourceforge.net/project/ptpd/ptpd/$(PTPD_VERSION)
PTPD_LICENSE = BSD
PTPD_LICENSE_FILES = COPYRIGHT

define PTPD_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/src
endef

define PTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/src/ptpd $(TARGET_DIR)/usr/sbin/ptpd
endef

define PTPD_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/ptpd/S65ptpd \
		$(TARGET_DIR)/etc/init.d/S65ptpd
endef

define PTPD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/ptpd/ptpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/ptpd.service
endef

$(eval $(generic-package))
