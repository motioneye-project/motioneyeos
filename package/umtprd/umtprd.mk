################################################################################
#
# umtprd
#
################################################################################

UMTPRD_VERSION = 1.0.0
UMTPRD_SITE = https://github.com/viveris/uMTP-Responder/archive
UMTPRD_LICENSE = GPL-3.0+
UMTPRD_LICENSE_FILES = LICENSE

define UMTPRD_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define UMTPRD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/umtprd $(TARGET_DIR)/usr/sbin/umtprd
endef

$(eval $(generic-package))
