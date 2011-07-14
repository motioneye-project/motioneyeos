#############################################################
#
# gnutls
#
#############################################################

GNUTLS_VERSION = 2.10.3
GNUTLS_SOURCE = gnutls-$(GNUTLS_VERSION).tar.bz2
GNUTLS_SITE = http://ftp.gnu.org/gnu/gnutls/
GNUTLS_DEPENDENCIES = libgcrypt
GNUTLS_CONF_OPT += --without-libgcrypt-prefix
GNUTLS_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package,gnutls))
