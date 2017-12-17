################################################################################
#
# putty
#
################################################################################

PUTTY_VERSION = 0.70
PUTTY_SITE = http://the.earth.li/~sgtatham/putty/$(PUTTY_VERSION)
PUTTY_SUBDIR = unix
PUTTY_LICENSE = MIT
PUTTY_LICENSE_FILES = LICENCE
PUTTY_CONF_OPTS = --disable-gtktest
PUTTY_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -Wno-error"

ifeq ($(BR2_PACKAGE_LIBGTK2),y)
PUTTY_CONF_OPTS += --with-gtk=2
PUTTY_DEPENDENCIES += libgtk2
else
PUTTY_CONF_OPTS += --without-gtk
endif

$(eval $(autotools-package))
