################################################################################
#
# arptables
#
################################################################################

ARPTABLES_VERSION = 0.0.4
ARPTABLES_SOURCE = arptables-v$(ARPTABLES_VERSION).tar.gz
ARPTABLES_SITE = http://downloads.sourceforge.net/project/ebtables/arptables/arptables-v$(ARPTABLES_VERSION)
ARPTABLES_LICENSE = GPLv2+

define ARPTABLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" COPT_FLAGS="$(TARGET_CFLAGS)"
endef

define ARPTABLES_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/arptables $(TARGET_DIR)/usr/sbin/arptables
endef

$(eval $(generic-package))
