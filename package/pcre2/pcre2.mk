################################################################################
#
# pcre2
#
################################################################################

PCRE2_VERSION = 10.23
PCRE2_SITE = https://ftp.pcre.org/pub/pcre
PCRE2_SOURCE = pcre2-$(PCRE2_VERSION).tar.bz2
PCRE2_LICENSE = BSD-3-Clause
PCRE2_LICENSE_FILES = LICENCE
PCRE2_INSTALL_STAGING = YES
PCRE2_CONFIG_SCRIPTS = pcre2-config

PCRE2_CONF_OPTS += --enable-pcre2-8
PCRE2_CONF_OPTS += $(if $(BR2_PACKAGE_PCRE2_16),--enable-pcre2-16,--disable-pcre2-16)
PCRE2_CONF_OPTS += $(if $(BR2_PACKAGE_PCRE2_32),--enable-pcre2-32,--disable-pcre2-32)

# disable fork usage if not available
ifeq ($(BR2_USE_MMU),)
PCRE2_CONF_OPTS += --disable-pcre2grep-callout
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
