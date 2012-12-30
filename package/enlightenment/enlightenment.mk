#############################################################
#
# enlightenment
#
#############################################################

ENLIGHTENMENT_VERSION = 0.17.0-omega
ENLIGHTENMENT_SITE = http://download.enlightenment.org/releases/
ENLIGHTENMENT_LICENSE = BSD-2c
ENLIGHTENMENT_LICENSE_FILES = COPYING

ENLIGHTENMENT_DEPENDENCIES = 	\
	host-pkgconf 		\
	libecore 		\
	libeet 			\
	libeina 		\
	libevas 		\
	libevas-generic-loaders \
	libedje 		\
	libefreet 		\
	libedbus 		\
	libeio 			\
	host-libedje 		\
	host-libeet		\
	xcb-util-keysyms

ENLIGHTENMENT_CONF_OPT = --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
			 --with-eet-eet=$(HOST_DIR)/usr/bin/eet \
			 --disable-rpath

ifeq ($(BR2_HAVE_DOCUMENTATION),)
define ENLIGHTENMENT_REMOVE_DOCUMENTATION
	rm -rf $(TARGET_DIR)/usr/share/enlightenment/doc/
	rm -f $(TARGET_DIR)/usr/share/enlightenment/COPYING
	rm -f $(TARGET_DIR)/usr/share/enlightenment/AUTHORS
endef
ENLIGHTENMENT_POST_INSTALL_TARGET_HOOKS += ENLIGHTENMENT_REMOVE_DOCUMENTATION
endif

$(eval $(autotools-package))
