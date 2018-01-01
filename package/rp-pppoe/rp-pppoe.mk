################################################################################
#
# rp-pppoe
#
################################################################################

RP_PPPOE_VERSION = 3.12
RP_PPPOE_SITE = http://www.roaringpenguin.com/files/download
RP_PPPOE_LICENSE = GPL-2.0
RP_PPPOE_LICENSE_FILES = doc/LICENSE
RP_PPPOE_DEPENDENCIES = pppd
RP_PPPOE_SUBDIR = src
RP_PPPOE_TARGET_FILES = pppoe pppoe-server pppoe-relay pppoe-sniff
RP_PPPOE_TARGET_SCRIPTS = pppoe-connect pppoe-init pppoe-setup pppoe-start \
	pppoe-status pppoe-stop
RP_PPPOE_MAKE_OPTS = PLUGIN_DIR=/usr/lib/pppd/$(PPPD_VERSION)
RP_PPPOE_CONF_OPTS = --disable-debugging

# The pppd, echo, setsid and id paths must be the ones on the
# target. Indeed, the result of these checks is used to replace
# variables in scripts that are installed in the target.
RP_PPPOE_CONF_ENV = \
	rpppoe_cv_pack_bitfields=normal \
	ac_cv_path_PPPD=/usr/sbin/pppd \
	ac_cv_path_ECHO=/bin/echo \
	ac_cv_path_SETSID=/usr/bin/setsid \
	ac_cv_path_ID=/usr/bin/id \
	PPPD_H=$(PPPD_DIR)/pppd/pppd.h

define RP_PPPOE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/configs/pppoe.conf \
		$(TARGET_DIR)/etc/ppp/pppoe.conf
	for ff in $(RP_PPPOE_TARGET_FILES); do \
		$(INSTALL) -m 0755 $(@D)/src/$$ff $(TARGET_DIR)/usr/sbin/$$ff || exit 1; \
	done
	for ff in $(RP_PPPOE_TARGET_SCRIPTS); do \
		$(INSTALL) -m 0755 $(@D)/scripts/$$ff $(TARGET_DIR)/usr/sbin/$$ff || exit 1; \
	done
endef

$(eval $(autotools-package))
