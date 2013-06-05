################################################################################
#
# mongoose
#
################################################################################

MONGOOSE_VERSION = 3.7
MONGOOSE_SOURCE = mongoose-$(MONGOOSE_VERSION).tgz
MONGOOSE_SITE = https://mongoose.googlecode.com/files
MONGOOSE_LICENSE = MIT
MONGOOSE_LICENSE_FILES = LICENSE

MONGOOSE_CFLAGS = $(TARGET_CFLAGS) $(TARGET_LDFLAGS)

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MONGOOSE_DEPENDENCIES += openssl
# directly linked
MONGOOSE_CFLAGS += -DNO_SSL_DL -lssl -lcrypto -lz
else
MONGOOSE_CFLAGS += -DNO_SSL
endif

define MONGOOSE_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) \
		linux COPT="$(MONGOOSE_CFLAGS)"
endef

define MONGOOSE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/mongoose $(TARGET_DIR)/usr/sbin/mongoose
	$(INSTALL) -D -m 755 package/mongoose/S85mongoose \
		$(TARGET_DIR)/etc/init.d/S85mongoose
endef

$(eval $(generic-package))
