################################################################################
#
# nmap
#
################################################################################

NMAP_VERSION = 6.47
NMAP_SITE = http://nmap.org/dist
NMAP_SOURCE = nmap-$(NMAP_VERSION).tar.bz2
NMAP_DEPENDENCIES = libpcap pcre
NMAP_CONF_OPTS = --without-liblua --without-zenmap \
	--with-libdnet=included --with-liblinear=included \
	--with-libpcre="$(STAGING_DIR)/usr" --without-ncat
NMAP_LICENSE = GPLv2
NMAP_LICENSE_FILES = COPYING

# for 0001-libdnet-wrapper-configure.patch
define NMAP_WRAPPER_EXEC
	chmod +x $(@D)/libdnet-stripped/configure.gnu
endef
NMAP_POST_PATCH_HOOKS += NMAP_WRAPPER_EXEC

ifeq ($(BR2_PACKAGE_OPENSSL),y)
NMAP_CONF_OPTS += --with-openssl="$(STAGING_DIR)/usr"
NMAP_DEPENDENCIES += openssl
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
