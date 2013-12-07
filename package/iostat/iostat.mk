################################################################################
#
# iostat
#
################################################################################

IOSTAT_VERSION = 2.2
IOSTAT_SITE = http://www.linuxinsight.com/files
IOSTAT_LICENSE = GPL
IOSTAT_LICENSE_FILES = LICENSE

iostat-source: $(DL_DIR)/$(IOSTAT_SOURCE)

define IOSTAT_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define IOSTAT_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(IOSTAT_DIR)/iostat $(TARGET_DIR)/usr/bin/iostat
	$(INSTALL) -D $(IOSTAT_DIR)/iostat.8 \
		$(TARGET_DIR)/usr/share/man/man8/iostat.8
endef

$(eval $(generic-package))
