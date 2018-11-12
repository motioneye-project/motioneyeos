################################################################################
#
# cifs-utils
#
################################################################################

CIFS_UTILS_VERSION = 6.8
CIFS_UTILS_SOURCE = cifs-utils-$(CIFS_UTILS_VERSION).tar.bz2
CIFS_UTILS_SITE = http://ftp.samba.org/pub/linux-cifs/cifs-utils
CIFS_UTILS_LICENSE = GPL-3.0+
CIFS_UTILS_LICENSE_FILES = COPYING
# Missing install-sh in release tarball
CIFS_UTILS_AUTORECONF = YES
CIFS_UTILS_DEPENDENCIES = host-pkgconf

# Let's disable PIE unconditionally. We want PIE to be enabled only by
# the global BR2_RELRO_FULL option.
CIFS_UTILS_CONF_OPTS = --disable-pie --disable-man

ifeq ($(BR2_PACKAGE_KEYUTILS),y)
CIFS_UTILS_DEPENDENCIES += keyutils
endif

define CIFS_UTILS_NO_WERROR
	$(SED) 's/-Werror//' $(@D)/Makefile.in
endef

CIFS_UTILS_POST_PATCH_HOOKS += CIFS_UTILS_NO_WERROR

$(eval $(autotools-package))
