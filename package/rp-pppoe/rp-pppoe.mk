################################################################################
#
# rp-pppoe
#
################################################################################

RP_PPPOE_VERSION = 3.11
RP_PPPOE_SITE = http://www.roaringpenguin.com/files/download
RP_PPPOE_LICENSE = GPLv2
RP_PPPOE_LICENSE_FILES = doc/LICENSE
RP_PPPOE_DEPENDENCIES = pppd
RP_PPPOE_SUBDIR = src
RP_PPPOE_TARGET_FILES = pppoe pppoe-server pppoe-relay pppoe-sniff
RP_PPPOE_MAKE_OPT = PLUGIN_DIR=/usr/lib/pppd/$(PPPD_VERSION)
RP_PPPOE_CONF_OPT = --disable-debugging
RP_PPPOE_CONF_ENV = \
	rpppoe_cv_pack_bitfields=normal \
	PPPD_H=$(PPPD_DIR)/pppd/pppd.h

define RP_PPPOE_INSTALL_TARGET_CMDS
	for ff in $(RP_PPPOE_TARGET_FILES); do \
		$(INSTALL) -m 0755 $(@D)/src/$$ff $(TARGET_DIR)/usr/sbin/$$ff; \
	done
	for ff in $(RP_PPPOE_TARGET_FILES); do \
		$(INSTALL) -m 644 -D $(RP_PPPOE_DIR)/man/$$ff.8 $(TARGET_DIR)/usr/share/man/man8/$$ff.8; \
	done
endef

define RP_PPPOE_UNINSTALL_TARGET_CMDS
	for ff in $(RP_PPPOE_TARGET_FILES); do \
		rm -f $(TARGET_DIR)/usr/sbin/$$ff; \
	done
	for ff in $(RP_PPPOE_TARGET_FILES); do \
		rm -f $(TARGET_DIR)/usr/share/man/man8/$$ff.8; \
	done
endef

$(eval $(autotools-package))
