################################################################################
#
# mongoose
#
################################################################################

MONGOOSE_VERSION = 6.7
MONGOOSE_SITE = $(call github,cesanta,mongoose,$(MONGOOSE_VERSION))
MONGOOSE_LICENSE = GPL-2.0
MONGOOSE_LICENSE_FILES = LICENSE
MONGOOSE_INSTALL_STAGING = YES

MONGOOSE_CFLAGS = $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -DMONGOOSE_NO_DL

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MONGOOSE_DEPENDENCIES += openssl
# directly linked
MONGOOSE_CFLAGS += -DNS_ENABLE_SSL -lssl -lcrypto -lz
endif

define MONGOOSE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CC) -c $(@D)/mongoose.c $(MONGOOSE_CFLAGS) -o $(@D)/mongoose.o
	$(TARGET_MAKE_ENV) $(TARGET_AR) rcs $(@D)/libmongoose.a $(@D)/mongoose.o
endef

define MONGOOSE_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/libmongoose.a \
		$(STAGING_DIR)/usr/lib/libmongoose.a
	$(INSTALL) -D -m 644 $(@D)/mongoose.h \
		$(STAGING_DIR)/usr/include/mongoose.h
endef

$(eval $(generic-package))
