#############################################################
#
# gnutls
#
#############################################################

GNUTLS_VERSION = 2.12.18
GNUTLS_SOURCE = gnutls-$(GNUTLS_VERSION).tar.bz2
GNUTLS_SITE = $(BR2_GNU_MIRROR)/gnutls
GNUTLS_DEPENDENCIES = host-pkg-config libgcrypt
GNUTLS_CONF_OPT = --with-libgcrypt --with-libgcrypt-prefix=$(STAGING_DIR)/usr \
		--without-p11-kit
GNUTLS_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS))
