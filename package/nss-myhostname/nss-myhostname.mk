################################################################################
#
## nss-myhostname
#
################################################################################

NSS_MYHOSTNAME_VERSION = 0.3
NSS_MYHOSTNAME_SITE = http://0pointer.de/lennart/projects/nss-myhostname
NSS_MYHOSTNAME_LICENSE = LGPL-2.1+
NSS_MYHOSTNAME_LICENSE_FILES = LICENSE

# add myhostname after files if missing
define MYHOSTNAME_SET_NSSWITCH
	$(SED) '/^hosts:/ {/myhostname/! s/files/files myhostname/}' \
		$(TARGET_DIR)/etc/nsswitch.conf
endef

NSS_MYHOSTNAME_TARGET_FINALIZE_HOOKS += MYHOSTNAME_SET_NSSWITCH

$(eval $(autotools-package))
