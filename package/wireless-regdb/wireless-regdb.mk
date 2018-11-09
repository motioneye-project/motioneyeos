################################################################################
#
# wireless-regdb
#
################################################################################

WIRELESS_REGDB_VERSION = 2018.05.31
WIRELESS_REGDB_SOURCE = wireless-regdb-$(WIRELESS_REGDB_VERSION).tar.xz
WIRELESS_REGDB_SITE = http://kernel.org/pub/software/network/wireless-regdb
WIRELESS_REGDB_LICENSE = ISC
WIRELESS_REGDB_LICENSE_FILES = LICENSE

define WIRELESS_REGDB_INSTALL_TARGET_CMDS
	$(INSTALL) -m 644 -D -T $(@D)/regulatory.bin \
		$(TARGET_DIR)/usr/lib/crda/regulatory.bin
	$(INSTALL) -m 644 -D -T $(@D)/sforshee.key.pub.pem \
		$(TARGET_DIR)/etc/wireless-regdb/pubkeys/sforshee.key.pub.pem
	$(INSTALL) -m 644 -D -T $(@D)/regulatory.db \
		$(TARGET_DIR)/lib/firmware/regulatory.db
	$(INSTALL) -m 644 -D -T $(@D)/regulatory.db.p7s \
		$(TARGET_DIR)/lib/firmware/regulatory.db.p7s
endef

$(eval $(generic-package))
