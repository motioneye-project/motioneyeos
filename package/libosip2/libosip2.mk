################################################################################
#
# libosip2
#
################################################################################

LIBOSIP2_VERSION = 5.1.1
LIBOSIP2_SITE = $(BR2_GNU_MIRROR)/osip
LIBOSIP2_INSTALL_STAGING = YES
LIBOSIP2_LICENSE = LGPL-2.1+
LIBOSIP2_LICENSE_FILES = COPYING

ifeq ($(BR2_arc),y)
# toolchain __arc__ define conflicts with libosip2 source
LIBOSIP2_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -U__arc__"
endif

LIBOSIP2_CONF_OPTS = \
	--enable-mt=$(if $(BR2_TOOLCHAIN_HAS_THREADS),yes,no)

$(eval $(autotools-package))
