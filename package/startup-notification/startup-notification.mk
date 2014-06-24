################################################################################
#
# startup-notification
#
################################################################################

STARTUP_NOTIFICATION_VERSION = 0.9
STARTUP_NOTIFICATION_SITE = http://freedesktop.org/software/startup-notification/releases
STARTUP_NOTIFICATION_INSTALL_STAGING = YES
STARTUP_NOTIFICATION_DEPENDENCIES = xlib_libX11
STARTUP_NOTIFICATION_CONF_ENV = lf_cv_sane_realloc=yes
STARTUP_NOTIFICATION_CONF_OPT = --with-x \
	--x-includes="$(STAGING_DIR)/usr/include/X11" \
	--x-libraries="$(STAGING_DIR)/usr/lib"
STARTUP_NOTIFICATION_LICENSE = LGPLv2
STARTUP_NOTIFICATION_LICENSE_FILES = COPYING

$(eval $(autotools-package))
