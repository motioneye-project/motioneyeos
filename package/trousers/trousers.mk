#############################################################
#
# trousers
#
##############################################################

TROUSERS_VERSION = 0.3.13
TROUSERS_SOURCE = trousers-$(TROUSERS_VERSION).tar.gz
TROUSERS_SITE = http://downloads.sourceforge.net/project/trousers/trousers/$(TROUSERS_VERSION)
TROUSERS_LICENSE = BSD-3c
TROUSERS_LICENSE_FILES = LICENSE
TROUSERS_INSTALL_STAGING = YES
# Need autoreconf because of a patch touching configure.in and Makefile.am
TROUSERS_AUTORECONF = YES
TROUSERS_DEPENDENCIES = host-pkgconf openssl

ifeq ($(BR2_PACKAGE_LIBICONV),y)
TROUSERS_DEPENDENCIES += libiconv
endif

# The TrouSerS build system attempts to create the tss user and group
# on the host system. Disable the user checking feature as a
# workaround.
TROUSERS_CONF_OPTS += --disable-usercheck

ifeq ($(BR2_TOOLCHAIN_SUPPORTS_PIE),)
TROUSERS_CONF_ENV += \
	ax_cv_check_cflags___fPIE__DPIE=no \
	ax_cv_check_ldflags___pie=no
endif

$(eval $(autotools-package))
