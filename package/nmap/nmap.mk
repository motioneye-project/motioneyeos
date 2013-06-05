################################################################################
#
# nmap
#
################################################################################

NMAP_VERSION = 6.01
NMAP_SITE = http://nmap.org/dist
NMAP_SOURCE = nmap-$(NMAP_VERSION).tar.bz2
NMAP_DEPENDENCIES = libpcap pcre
NMAP_CONF_OPT = --without-liblua --without-zenmap \
	--with-libdnet=included --with-liblinear=included \
	--with-libpcre="$(STAGING_DIR)/usr"
NMAP_LICENSE = GPLv2
NMAP_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_OPENSSL),y)
NMAP_CONF_OPT += --with-openssl="$(STAGING_DIR)/usr"
NMAP_DEPENDENCIES += openssl
else
NMAP_CONF_OPT += --without-openssl
endif

$(eval $(autotools-package))
