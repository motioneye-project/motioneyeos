#############################################################
#
# nss_mdns
#
#############################################################
NSS_MDNS_VERSION=0.10
NSS_MDNS_SITE=http://0pointer.de/lennart/projects/nss-mdns

define NSS_MDNS_INSTALL_CONFIG
	$(INSTALL) -D -m 0664 package/nss-mdns/nsswitch.conf $(TARGET_DIR)/etc/nsswitch.conf
endef

NSS_MDNS_POST_INSTALL_TARGET_HOOKS += NSS_MDNS_INSTALL_CONFIG

$(eval $(autotools-package))
