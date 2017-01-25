################################################################################
#
# sngrep
#
################################################################################

SNGREP_VERSION = v1.4.2
SNGREP_SITE = $(call github,irontec,sngrep,$(SNGREP_VERSION))
SNGREP_LICENSE = GPLv3+
SNGREP_LICENSE_FILES = LICENSE
SNGREP_AUTORECONF = YES
SNGREP_DEPENDENCIES = libpcap ncurses

# our ncurses wchar support is not properly detected
SNGREP_CONF_OPTS += --disable-unicode

ifeq ($(BR2_PACKAGE_GNUTLS),y)
SNGREP_DEPENDENCIES += gnutls
SNGREP_CONF_OPTS += --with-gnutls
else
SNGREP_CONF_OPTS += --without-gnutls
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
SNGREP_DEPENDENCIES += openssl
SNGREP_CONF_OPTS += --with-openssl
else
SNGREP_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
SNGREP_DEPENDENCIES += pcre
SNGREP_CONF_OPTS += --with-pcre
else
SNGREP_CONF_OPTS += --without-pcre
endif

$(eval $(autotools-package))
