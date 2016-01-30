################################################################################
#
# lightning
#
################################################################################

LIGHTNING_VERSION = 2.1.0
LIGHTNING_SITE = http://ftp.gnu.org/gnu/lightning
LIGHTNING_LICENSE = LGPLv3+
LIGHTNING_LICENSE_FILES = COPYING.LESSER
LIGHTNING_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LIGHTNING_DISASSEMBLER),y)
LIGHTNING_DEPENDENCIES += binutils zlib
LIGHTNING_CONF_OPTS += --enable-disassembler
# binutils libraries are not explicitly linked against gettext
LIGHTNING_CONF_ENV += $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),LIBS=-lintl)
endif

$(eval $(autotools-package))
