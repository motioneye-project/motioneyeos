#############################################################
#
# iw
#
#############################################################

IW_VERSION = 3.5
IW_SOURCE = iw-$(IW_VERSION).tar.bz2
IW_SITE = http://wireless.kernel.org/download/iw
IW_DEPENDENCIES = host-pkg-config libnl
IW_CONFIG = $(IW_DIR)/.config
IW_MAKE_ENV = PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig" \
	PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
	GIT_DIR=$(IW_DIR)

ifeq ($(BR2_PREFER_STATIC_LIB),y)
# libnl needs pthread/m, so we need to explicitly with them when static
# these need to added AFTER libnl, so we have to override LIBS completely
IW_MAKE_OPT = LIBS='-lnl-genl-3 -lnl-3 -lpthread -lm'
endif

define IW_CONFIGURE_CMDS
	echo "CC = $(TARGET_CC)" >$(IW_CONFIG)
	echo "CFLAGS = $(TARGET_CFLAGS)" >>$(IW_CONFIG)
	echo "LDFLAGS = $(TARGET_LDFLAGS)" >>$(IW_CONFIG)
endef

define IW_BUILD_CMDS
	$(IW_MAKE_ENV) $(MAKE) $(IW_MAKE_OPT) -C $(@D)
endef

define IW_INSTALL_TARGET_CMDS
	$(IW_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define IW_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/iw
	rm -f $(TARGET_DIR)/usr/share/man/man8/iw.8*
endef

$(eval $(generic-package))
