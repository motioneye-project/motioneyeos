#############################################################
#
# startup-notification
#
#############################################################
STARTUP_NOTIFICATION_VERSION = 0.9
STARTUP_NOTIFICATION_SOURCE = startup-notification-$(STARTUP_NOTIFICATION_VERSION).tar.gz
STARTUP_NOTIFICATION_SITE = http://freedesktop.org/software/startup-notification/releases
STARTUP_NOTIFICATION_AUTORECONF = NO
STARTUP_NOTIFICATION_INSTALL_STAGING = YES
STARTUP_NOTIFICATION_INSTALL_TARGET = YES

STARTUP_NOTIFICATION_CONF_ENV = lf_cv_sane_realloc=yes

STARTUP_NOTIFICATION_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,startup-notification))

