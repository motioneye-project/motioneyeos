################################################################################
#
# mongoose
#
################################################################################

MONGOOSE_VERSION = 5.3
MONGOOSE_SITE = $(call github,cesanta,mongoose,$(MONGOOSE_VERSION))
MONGOOSE_LICENSE = GPLv2
MONGOOSE_LICENSE_FILES = LICENSE

MONGOOSE_CFLAGS = $(TARGET_CFLAGS) $(TARGET_LDFLAGS)

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MONGOOSE_DEPENDENCIES += openssl
# directly linked
MONGOOSE_CFLAGS += -DNS_ENABLE_SSL -lssl -lcrypto -lz
endif

define MONGOOSE_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)/examples \
		CFLAGS_EXTRA="$(MONGOOSE_CFLAGS)" server
endef

define MONGOOSE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/examples/server $(TARGET_DIR)/usr/sbin/mongoose
	$(INSTALL) -D -m 755 package/mongoose/S85mongoose \
		$(TARGET_DIR)/etc/init.d/S85mongoose
endef

$(eval $(generic-package))
