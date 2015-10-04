################################################################################
#
# mongoose
#
################################################################################

MONGOOSE_VERSION = 5.6
MONGOOSE_SITE = $(call github,cesanta,mongoose,$(MONGOOSE_VERSION))
MONGOOSE_LICENSE = GPLv2
MONGOOSE_LICENSE_FILES = LICENSE
MONGOOSE_INSTALL_STAGING = YES

MONGOOSE_CFLAGS = $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -DMONGOOSE_NO_DL

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MONGOOSE_DEPENDENCIES += openssl
# directly linked
MONGOOSE_CFLAGS += -DNS_ENABLE_SSL -lssl -lcrypto -lz
endif

define MONGOOSE_BUILD_CMDS
	$(TARGET_CC) $(@D)/examples/web_server/web_server.c $(@D)/mongoose.c \
		-I$(@D) -o $(@D)/examples/web_server/web_server \
		$(MONGOOSE_CFLAGS) -pthread
	$(TARGET_CC) -c $(@D)/mongoose.c $(MONGOOSE_CFLAGS) -o $(@D)/mongoose.o
	$(TARGET_AR) rcs $(@D)/libmongoose.a $(@D)/mongoose.o
endef

define MONGOOSE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/examples/web_server/web_server \
		$(TARGET_DIR)/usr/sbin/mongoose
endef

define MONGOOSE_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/mongoose/S85mongoose \
		$(TARGET_DIR)/etc/init.d/S85mongoose
endef

define MONGOOSE_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/mongoose/mongoose.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mongoose.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/mongoose.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/mongoose.service
endef

define MONGOOSE_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/libmongoose.a \
		$(STAGING_DIR)/usr/lib/libmongoose.a
	$(INSTALL) -D -m 644 $(@D)/mongoose.h \
		$(STAGING_DIR)/usr/include/mongoose.h
endef

$(eval $(generic-package))
