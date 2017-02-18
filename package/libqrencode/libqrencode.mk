################################################################################
#
# libqrencode
#
################################################################################

LIBQRENCODE_VERSION = 3.4.2
LIBQRENCODE_SOURCE = qrencode-$(LIBQRENCODE_VERSION).tar.gz
LIBQRENCODE_SITE = http://fukuchi.org/works/qrencode
LIBQRENCODE_DEPENDENCIES = host-pkgconf
LIBQRENCODE_INSTALL_STAGING = YES
LIBQRENCODE_LICENSE = LGPLv2.1+
LIBQRENCODE_LICENSE_FILES = COPYING

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
LIBQRENCODE_CONF_ENV += LIBS='-pthread'
else
LIBQRENCODE_CONF_OPTS += --disable-thread-safety
endif

ifeq ($(BR2_PACKAGE_LIBQRENCODE_TOOLS),y)
LIBQRENCODE_CONF_OPTS += --with-tools=yes
LIBQRENCODE_DEPENDENCIES += libpng
else
LIBQRENCODE_CONF_OPTS += --with-tools=no
endif

$(eval $(autotools-package))
