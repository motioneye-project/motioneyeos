################################################################################
#
# nmap
#
################################################################################

NMAP_VERSION = 7.70
NMAP_SITE = https://nmap.org/dist
NMAP_SOURCE = nmap-$(NMAP_VERSION).tar.bz2
NMAP_DEPENDENCIES = liblinear libpcap
NMAP_CONF_OPTS = --without-liblua --without-zenmap \
	--with-libdnet=included
NMAP_LICENSE = nmap license
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

NMAP_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR)

ifeq ($(BR2_PACKAGE_NMAP_NCAT),y)
NMAP_CONF_OPTS += --with-ncat
NMAP_MAKE_OPTS += build-ncat
NMAP_INSTALL_TARGET_OPTS += install-ncat
else
NMAP_CONF_OPTS += --without-ncat
endif

ifeq ($(BR2_PACKAGE_NMAP_NDIFF),y)
NMAP_DEPENDENCIES += python
NMAP_CONF_OPTS += --with-ndiff
NMAP_MAKE_OPTS += build-ndiff
NMAP_INSTALL_TARGET_OPTS += install-ndiff
else
NMAP_CONF_OPTS += --without-ndiff
endif

ifeq ($(BR2_PACKAGE_NMAP_NMAP),y)
NMAP_DEPENDENCIES += pcre
NMAP_CONF_OPTS += --with-libpcre="$(STAGING_DIR)/usr"
NMAP_MAKE_OPTS += nmap
NMAP_INSTALL_TARGET_OPTS += install-nmap
endif

ifeq ($(BR2_PACKAGE_NMAP_NPING),y)
NMAP_CONF_OPTS += --with-nping
NMAP_MAKE_OPTS += build-nping
NMAP_INSTALL_TARGET_OPTS += install-nping
else
NMAP_CONF_OPTS += --without-nping
endif

# Add a symlink to "nc" if none of the competing netcats is selected
ifeq ($(BR2_PACKAGE_NMAP_NCAT):$(BR2_PACKAGE_NETCAT)$(BR2_PACKAGE_NETCAT_OPENBSD),y:)
define NMAP_INSTALL_NCAT_SYMLINK
	ln -fs ncat $(TARGET_DIR)/usr/bin/nc
endef
NMAP_POST_INSTALL_TARGET_HOOKS += NMAP_INSTALL_NCAT_SYMLINK
endif

$(eval $(autotools-package))
