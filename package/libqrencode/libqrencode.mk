################################################################################
#
# libqrencode
#
################################################################################

LIBQRENCODE_VERSION = 3.4.2
LIBQRENCODE_SOURCE = qrencode-$(LIBQRENCODE_VERSION).tar.gz
LIBQRENCODE_SITE = http://fukuchi.org/works/qrencode
LIBQRENCODE_DEPENDENCIES = libpng
LIBQRENCODE_INSTALL_STAGING = YES
LIBQRENCODE_LICENSE = LGPLv2.1+
LIBQRENCODE_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBQRENCODE_TOOLS),y)
        LIBQRENCODE_CONF_OPT += --with-tools=yes
else
        LIBQRENCODE_CONF_OPT += --with-tools=no
endif

$(eval $(autotools-package))
