################################################################################
#
# sunxi-cedarx
#
################################################################################

SUNXI_CEDARX_VERSION = 74923e55fc
SUNXI_CEDARX_SITE = http://github.com/linux-sunxi/cedarx-libs/tarball/$(SUNXI_CEDARX_VERSION)

SUNXI_CEDARX_INSTALL_STAGING = YES

ifeq ($(BR2_ARM_EABIHF),y)
SUNXI_CEDARX_BIN_DIR = $(@D)/libcedarv/linux-armhf
else
SUNXI_CEDARX_BIN_DIR = $(@D)/libcedarv/linux-armel
endif

define SUNXI_CEDARX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(SUNXI_CEDARX_BIN_DIR)
	$(TARGET_CC) $(TARGET_CFLAGS) \
		-c $(SUNXI_CEDARX_BIN_DIR)/adapter/avheap/avheap.c \
		-o $(SUNXI_CEDARX_BIN_DIR)/adapter/avheap/avheap.o \
		-I $(SUNXI_CEDARX_BIN_DIR)/adapter/avheap \
		-I $(SUNXI_CEDARX_BIN_DIR)/
	$(TARGET_CC) -shared -L./ -Wl,-soname,libavheap.so \
		-o $(SUNXI_CEDARX_BIN_DIR)/adapter/avheap/libavheap.so \
		$(SUNXI_CEDARX_BIN_DIR)/adapter/avheap/avheap.o
endef

define SUNXI_CEDARX_INSTALL_STAGING_CMDS
	$(INSTALL) -d -m 755 $(STAGING_DIR)/usr/include/libvecore
	$(INSTALL) -m 664 $(SUNXI_CEDARX_BIN_DIR)/libvecore/*.h \
		$(STAGING_DIR)/usr/include/libvecore
	$(INSTALL) -m 644 $(SUNXI_CEDARX_BIN_DIR)/*.h \
		$(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 755 $(SUNXI_CEDARX_BIN_DIR)/libvecore/libvecore.so \
		$(STAGING_DIR)/usr/lib/libvecore.so
	$(INSTALL) -D -m 755 $(SUNXI_CEDARX_BIN_DIR)/adapter/avheap/libavheap.so \
		$(STAGING_DIR)/usr/lib/libavheap.so
endef

define SUNXI_CEDARX_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(SUNXI_CEDARX_BIN_DIR)/libvecore/libvecore.so \
		$(TARGET_DIR)/usr/lib/libvecore.so
	$(INSTALL) -D -m 755 $(SUNXI_CEDARX_BIN_DIR)/adapter/avheap/libavheap.so \
		$(TARGET_DIR)/usr/lib/libavheap.so
endef

$(eval $(generic-package))
