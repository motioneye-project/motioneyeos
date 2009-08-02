#############################################################
#
# iw
#
#############################################################

IW_VERSION = 0.9.15
IW_SOURCE = iw-$(IW_VERSION).tar.bz2
IW_SITE = http://wireless.kernel.org/download/iw
IW_DEPENDENCIES = libnl
IW_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
IW_CONFIG = $(IW_DIR)/.config
IW_MAKE_ENV = PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig" \
	GIT_DIR=$(IW_DIR)

$(eval $(call AUTOTARGETS,package,iw))

$(IW_TARGET_CONFIGURE):
	echo "CC = $(TARGET_CC)" >$(IW_CONFIG)
	echo "CFLAGS = $(TARGET_CFLAGS)" >>$(IW_CONFIG)
	echo "LDFLAGS = $(TARGET_LDFLAGS)" >>$(IW_CONFIG)
	touch $@

$(IW_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/bin/iw
	rm -f $(IW_TARGET_INSTALL_TARGET) $(IW_HOOK_POST_INSTALL)
