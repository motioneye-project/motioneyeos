################################################################################
#
# liblogging
#
################################################################################

LIBLOGGING_VERSION = 1.0.2
LIBLOGGING_SITE = http://download.rsyslog.com/liblogging
LIBLOGGING_LICENSE = BSD-2c
LIBLOGGING_LICENSE_FILES = COPYING
LIBLOGGING_INSTALL_STAGING = YES
LIBLOGGING_CONF_OPT = --enable-cached-man-pages

ifeq ($(BR2_INIT_SYSTEMD),y)
LIBLOGGING_CONF_OPT += --enable-journal
LIBLOGGING_DEPENDENCIES += systemd
else
LIBLOGGING_CONF_OPT += --disable-journal
endif

$(eval $(autotools-package))
