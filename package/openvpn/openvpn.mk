#############################################################
#
# openvpn
#
#############################################################

OPENVPN_VERSION = 2.1.1
OPENVPN_SITE = http://openvpn.net/release
OPENVPN_CONF_OPT = --enable-small

ifeq ($(BR2_PTHREADS_NATIVE),y)
	OPENVPN_CONF_OPT += --enable-threads=posix
else
	OPENVPN_CONF_OPT += --enable-pthread
endif

ifeq ($(BR2_PACKAGE_OPENVPN_LZO),y)
	OPENVPN_DEPENDENCIES += lzo
else
	OPENVPN_CONF_OPT += --disable-lzo
endif

ifeq ($(BR2_PACKAGE_OPENVPN_OPENSSL),y)
	OPENVPN_DEPENDENCIES += openssl
else
	OPENVPN_CONF_OPT += --disable-crypto --disable-ssl
endif

$(eval $(call AUTOTARGETS,package,openvpn))

$(OPENVPN_TARGET_INSTALL_TARGET):
	$(call MESSAGE,"Installing")
	$(INSTALL) -m 755 $(OPENVPN_DIR)/openvpn \
		$(TARGET_DIR)/usr/sbin/openvpn
	if [ ! -f $(TARGET_DIR)/etc/init.d/openvpn ]; then \
		$(INSTALL) -m 755 -D package/openvpn/openvpn.init \
			$(TARGET_DIR)/etc/init.d/openvpn; \
	fi
	touch $@

$(OPENVPN_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/sbin/openvpn
	rm -f $(TARGET_DIR)/etc/init.d/openvpn
	rm -f $(OPENVPN_TARGET_INSTALL_TARGET) $(OPENVPN_HOOK_POST_INSTALL)
