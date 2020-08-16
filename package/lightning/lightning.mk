################################################################################
#
# lightning
#
################################################################################

LIGHTNING_VERSION = 2.1.3
LIGHTNING_SITE = $(BR2_GNU_MIRROR)/lightning
LIGHTNING_LICENSE = LGPL-3.0+
LIGHTNING_LICENSE_FILES = COPYING.LESSER
LIGHTNING_INSTALL_STAGING = YES
# We're patching include/Makefile.am
LIGHTNING_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIGHTNING_DISASSEMBLER),y)
LIGHTNING_DEPENDENCIES += binutils zlib
LIGHTNING_CONF_OPTS += --enable-disassembler
endif

$(eval $(autotools-package))
