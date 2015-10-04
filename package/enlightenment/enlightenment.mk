################################################################################
#
# enlightenment
#
################################################################################

ENLIGHTENMENT_VERSION = 0.17.6
ENLIGHTENMENT_SITE = http://download.enlightenment.org/releases
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

ENLIGHTENMENT_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eet-eet=$(HOST_DIR)/usr/bin/eet \
	--disable-rpath

# uClibc has an old incomplete sys/ptrace.h for powerpc & sparc
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC)$(BR2_powerpc)$(BR2_sparc),yy)
ENLIGHTENMENT_CONF_ENV += ac_cv_header_sys_ptrace_h=no
endif

# alsa backend needs mixer support
ifeq ($(BR2_PACKAGE_ALSA_LIB)$(BR2_PACKAGE_ALSA_LIB_MIXER),yy)
ENLIGHTENMENT_DEPENDENCIES += alsa-lib
else
ENLIGHTENMENT_CONF_ENV += enable_alsa=no
endif

define ENLIGHTENMENT_REMOVE_DOCUMENTATION
	rm -rf $(TARGET_DIR)/usr/share/enlightenment/doc/
	rm -f $(TARGET_DIR)/usr/share/enlightenment/COPYING
	rm -f $(TARGET_DIR)/usr/share/enlightenment/AUTHORS
endef
ENLIGHTENMENT_POST_INSTALL_TARGET_HOOKS += ENLIGHTENMENT_REMOVE_DOCUMENTATION

$(eval $(autotools-package))
