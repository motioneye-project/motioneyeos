################################################################################
#
# nmap
#
################################################################################

NMAP_VERSION = 7.60
NMAP_SITE = https://nmap.org/dist
NMAP_SOURCE = nmap-$(NMAP_VERSION).tar.bz2
NMAP_DEPENDENCIES = libpcap pcre
NMAP_CONF_OPTS = --without-liblua --without-zenmap \
	--with-libdnet=included --with-liblinear=included \
	--with-libpcre="$(STAGING_DIR)/usr" --without-ncat
NMAP_LICENSE = GPL-2.0
NMAP_LICENSE_FILES = COPYING

# needed by libpcap
NMAP_LIBS_FOR_STATIC_LINK += `$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`

ifeq ($(BR2_STATIC_LIBS),y)
NMAP_CONF_ENV += LIBS="$(NMAP_LIBS_FOR_STATIC_LINK)"
endif

# for 0001-libdnet-wrapper-configure.patch
define NMAP_WRAPPER_EXEC
	chmod +x $(@D)/libdnet-stripped/configure.gnu
endef
NMAP_POST_PATCH_HOOKS += NMAP_WRAPPER_EXEC

ifeq ($(BR2_PACKAGE_LIBSSH2),y)
NMAP_CONF_OPTS += --with-libssh2="$(STAGING_DIR)/usr"
NMAP_DEPENDENCIES += libssh2
NMAP_LIBS_FOR_STATIC_LINK += `$(PKG_CONFIG_HOST_BINARY) --libs libssh2`
else
NMAP_CONF_OPTS += --without-libssh2
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
NMAP_CONF_OPTS += --with-openssl="$(STAGING_DIR)/usr"
NMAP_DEPENDENCIES += host-pkgconf openssl
NMAP_LIBS_FOR_STATIC_LINK += `$(PKG_CONFIG_HOST_BINARY) --libs openssl`
else
NMAP_CONF_OPTS += --without-openssl
endif

# ndiff only works with python2.x
ifeq ($(BR2_PACKAGE_PYTHON),y)
NMAP_DEPENDENCIES += python
else
NMAP_CONF_OPTS += --without-ndiff
endif

$(eval $(autotools-package))
