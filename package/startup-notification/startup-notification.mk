#############################################################
#
# startup-notification
#
#############################################################
STARTUP_NOTIFICATION_VERSION = 0.9
STARTUP_NOTIFICATION_SOURCE = startup-notification-$(STARTUP_NOTIFICATION_VERSION).tar.gz
STARTUP_NOTIFICATION_SITE = http://freedesktop.org/software/startup-notification/releases
STARTUP_NOTIFICATION_INSTALL_STAGING = YES
STARTUP_NOTIFICATION_DEPENDENCIES = xlib_libX11
STARTUP_NOTIFICATION_CONF_ENV = lf_cv_sane_realloc=yes
STARTUP_NOTIFICATION_CONF_OPT = --with-x \
	--x-includes="$(STAGING_DIR)/usr/include/X11" \
	--x-libraries="$(STAGING_DIR)/usr/lib"

$(eval $(autotools-package))

