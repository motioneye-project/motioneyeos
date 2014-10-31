################################################################################
#
# pixman
#
################################################################################

PIXMAN_VERSION = 0.32.6
PIXMAN_SITE = http://xorg.freedesktop.org/releases/individual/lib
PIXMAN_LICENSE = MIT
PIXMAN_LICENSE_FILES = COPYING

PIXMAN_INSTALL_STAGING = YES
PIXMAN_DEPENDENCIES = host-pkgconf
PIXMAN_AUTORECONF = YES

# don't build gtk based demos
PIXMAN_CONF_OPTS = --disable-gtk

# disable iwmmxt support for CPU's that don't have
# this feature
ifneq ($(BR2_iwmmxt),y)
PIXMAN_CONF_OPTS += --disable-arm-iwmmxt
endif

# toolchain gets confused about TLS access through GOT (PIC), so disable TLS
# movhi	r4, %got_hiadj(%tls_ldo(fast_path_cache))
# {standard input}:172: Error: bad expression
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_NIOSII201405),y)
PIXMAN_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -DPIXMAN_NO_TLS"
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
