################################################################################
#
# iostat
#
################################################################################

IOSTAT_VERSION = 2.2
IOSTAT_SITE = http://linuxinsight.com/sites/default/files
IOSTAT_LICENSE = GPL
IOSTAT_LICENSE_FILES = LICENSE

define IOSTAT_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -DHZ=100"
endef

define IOSTAT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(IOSTAT_DIR)/iostat $(TARGET_DIR)/usr/bin/iostat
endef

$(eval $(generic-package))
