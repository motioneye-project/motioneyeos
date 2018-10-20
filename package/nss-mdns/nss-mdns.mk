################################################################################
#
# nss-mdns
#
################################################################################

NSS_MDNS_VERSION = 0.10
NSS_MDNS_SITE = http://0pointer.de/lennart/projects/nss-mdns
NSS_MDNS_LICENSE = LGPL-2.1+
NSS_MDNS_LICENSE_FILES = LICENSE

# add mdns4_minimal / mdns around the dns provider if missing
define NSS_MDNS_INSTALL_CONFIG
	$(SED) '/^hosts:/ {/mdns4/! s/dns/mdns4_minimal [NOTFOUND=return] dns mdns4/}' \
		$(TARGET_DIR)/etc/nsswitch.conf
endef

NSS_MDNS_TARGET_FINALIZE_HOOKS += NSS_MDNS_INSTALL_CONFIG

$(eval $(autotools-package))
