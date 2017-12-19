################################################################################
#
# smstools3
#
################################################################################

SMSTOOLS3_VERSION = 3.1.15
SMSTOOLS3_SITE = http://smstools3.kekekasvi.com/packages
SMSTOOLS3_LICENSE = GPL-2.0+
SMSTOOLS3_LICENSE_FILES = doc/license.html LICENSE

SMSTOOLS3_CFLAGS = $(TARGET_CFLAGS)
SMSTOOLS3_CFLAGS += -D NUMBER_OF_MODEMS=$(BR2_PACKAGE_SMSTOOLS3_NB_MODEMS)
SMSTOOLS3_CFLAGS += -D NOSTATS

define SMSTOOLS3_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CFLAGS="$(SMSTOOLS3_CFLAGS)" -C $(@D)
endef

define SMSTOOLS3_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/smstools3/S50smsd \
		$(TARGET_DIR)/etc/init.d/S50smsd
endef

define SMSTOOLS3_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/src/smsd \
		$(TARGET_DIR)/usr/bin/smsd
	$(INSTALL) -m 0755 -D $(@D)/scripts/sendsms \
		$(TARGET_DIR)/usr/bin/sendsms
	$(INSTALL) -m 0644 -D $(@D)/examples/smsd.conf.easy \
		$(TARGET_DIR)/etc/smsd.conf
endef

$(eval $(generic-package))
