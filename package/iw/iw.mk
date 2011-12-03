#############################################################
#
# iw
#
#############################################################

IW_VERSION = a82abc2cac9dea7def53070565201145c76c8c6c
IW_SITE = git://git.sipsolutions.net/iw.git
IW_DEPENDENCIES = host-pkg-config libnl
IW_CONFIG = $(IW_DIR)/.config
IW_MAKE_ENV = PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig" \
	PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
	GIT_DIR=$(IW_DIR)

define IW_CONFIGURE_CMDS
	echo "CC = $(TARGET_CC)" >$(IW_CONFIG)
	echo "CFLAGS = $(TARGET_CFLAGS)" >>$(IW_CONFIG)
	echo "LDFLAGS = $(TARGET_LDFLAGS)" >>$(IW_CONFIG)
endef

define IW_BUILD_CMDS
	$(IW_MAKE_ENV) $(MAKE) -C $(@D)
endef

define IW_INSTALL_TARGET_CMDS
	$(IW_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define IW_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/iw
	rm -f $(TARGET_DIR)/usr/share/man/man8/iw.8*
endef

$(eval $(call GENTARGETS))
