################################################################################
#
# libdrm
#
################################################################################

LIBDRM_VERSION = 2.4.46
LIBDRM_SOURCE = libdrm-$(LIBDRM_VERSION).tar.bz2
LIBDRM_SITE = http://dri.freedesktop.org/libdrm/
LIBDRM_LICENSE = MIT

LIBDRM_INSTALL_STAGING = YES

LIBDRM_DEPENDENCIES = \
	xlib_libpthread-stubs \
	host-pkgconf

LIBDRM_CONF_OPT = \
	--disable-cairo-tests \
	--disable-manpages

ifeq ($(BR2_PACKAGE_LIBDRM_INTEL),y)
LIBDRM_CONF_OPT += --enable-intel
LIBDRM_DEPENDENCIES += libatomic_ops xlib_libpciaccess
else
LIBDRM_CONF_OPT += --disable-intel
endif

ifeq ($(BR2_PACKAGE_LIBDRM_RADEON),y)
LIBDRM_CONF_OPT += --enable-radeon
LIBDRM_DEPENDENCIES += xlib_libpciaccess
else
LIBDRM_CONF_OPT += --disable-radeon
endif

ifeq ($(BR2_PACKAGE_LIBDRM_NOUVEAU),y)
LIBDRM_CONF_OPT += --enable-nouveau
LIBDRM_DEPENDENCIES += xlib_libpciaccess
else
LIBDRM_CONF_OPT += --disable-nouveau
endif

ifeq ($(BR2_PACKAGE_LIBDRM_VMWGFX),y)
LIBDRM_CONF_OPT += --enable-vmwgfx
LIBDRM_DEPENDENCIES += xlib_libpciaccess
else
LIBDRM_CONF_OPT += --disable-vmwgfx
endif

ifeq ($(BR2_PACKAGE_LIBDRM_OMAP),y)
LIBDRM_CONF_OPT += --enable-omap-experimental-api
else
LIBDRM_CONF_OPT += --disable-omap-experimental-api
endif

ifeq ($(BR2_PACKAGE_LIBDRM_EXYNOS),y)
LIBDRM_CONF_OPT += --enable-exynos-experimental-api
else
LIBDRM_CONF_OPT += --disable-exynos-experimental-api
endif

ifeq ($(BR2_PACKAGE_LIBDRM_FREEDRENO),y)
LIBDRM_CONF_OPT += --enable-freedreno-experimental-api
else
LIBDRM_CONF_OPT += --disable-freedreno-experimental-api
endif

ifeq ($(BR2_PACKAGE_UDEV),y)
LIBDRM_CONF_OPT += --enable-udev
LIBDRM_DEPENDENCIES += udev
else
LIBDRM_CONF_OPT += --disable-udev
endif

$(eval $(autotools-package))
