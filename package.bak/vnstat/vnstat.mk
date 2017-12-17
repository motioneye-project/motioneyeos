################################################################################
#
# vnstat
#
################################################################################

VNSTAT_VERSION = 1.15
VNSTAT_SITE = http://humdi.net/vnstat
VNSTAT_LICENSE = GPLv2
VNSTAT_LICENSE_FILES = COPYING
VNSTAT_DEPENDENCIES = host-pkgconf
# We're patching configure.ac, so we need to autoreconf
VNSTAT_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_GD)$(BR2_PACKAGE_LIBPNG),yy)
VNSTAT_DEPENDENCIES += gd
VNSTAT_CONF_OPTS = --enable-image-output
else
VNSTAT_CONF_OPTS = --disable-image-output
endif

# vnStat declares an 'install-data-hook' rule that tries to run
# 'vnstat --showconfig' on the host to generate a default config file.
# That obviously doesn't work when cross-compiling, so avoid it
# entirely.
VNSTAT_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) install-exec

$(eval $(autotools-package))
