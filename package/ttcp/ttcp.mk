################################################################################
#
# ttcp
#
################################################################################

#
TTCP_VERSION =
TTCP_SITE    = http://ftp.sunet.se/pub/network/monitoring/ttcp
TTCP_SOURCE  = ttcp.c
TTCP_LICENSE = public domain

define TTCP_EXTRACT_CMDS
	cp -f -t $(@D) $(DL_DIR)/$(TTCP_SOURCE)
endef

define TTCP_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CPPFLAGS) $(TARGET_CFLAGS) \
		-o $(@D)/ttcp $(@D)/$(TTCP_SOURCE)
endef

define TTCP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/ttcp $(TARGET_DIR)/usr/bin/ttcp
endef

$(eval $(generic-package))
