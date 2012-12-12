#############################################################
#
# mongoose
#
#############################################################

MONGOOSE_VERSION = 3.3
MONGOOSE_SOURCE = mongoose-$(MONGOOSE_VERSION).tgz
MONGOOSE_SITE = https://mongoose.googlecode.com/files
MONGOOSE_LICENSE = MIT
MONGOOSE_LICENSE_FILES = COPYING

MONGOOSE_CFLAGS = $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -DNO_SSL

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
