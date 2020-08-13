################################################################################
#
# arptables
#
################################################################################

ARPTABLES_VERSION = 0.0.5
ARPTABLES_SITE = http://ftp.netfilter.org/pub/arptables
ARPTABLES_LICENSE = GPL-2.0+
ARPTABLES_LICENSE_FILES = COPYING

define ARPTABLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" COPT_FLAGS="$(TARGET_CFLAGS)"
endef

define ARPTABLES_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/arptables-legacy \
		$(TARGET_DIR)/usr/sbin/arptables-legacy
endef

$(eval $(generic-package))
