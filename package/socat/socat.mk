################################################################################
#
# socat
#
################################################################################

SOCAT_VERSION = 2.0.0-b9
SOCAT_SOURCE = socat-$(SOCAT_VERSION).tar.bz2
SOCAT_SITE = http://www.dest-unreach.org/socat/download
SOCAT_LICENSE = GPL-2.0
SOCAT_LICENSE_FILES = COPYING

SOCAT_CONF_ENV = sc_cv_termios_ispeed=no

ifeq ($(BR2_powerpc)$(BR2_powerpc64)$(BR2_powerpc64le),y)
SOCAT_CONF_ENV += \
	sc_cv_sys_crdly_shift=12 \
	sc_cv_sys_tabdly_shift=10 \
	sc_cv_sys_csize_shift=8
else
SOCAT_CONF_ENV += \
	sc_cv_sys_crdly_shift=9 \
	sc_cv_sys_tabdly_shift=11 \
	sc_cv_sys_csize_shift=4
endif

# We need to run autoconf to regenerate the configure script, in order
# to ensure that the test checking linux/ext2_fs.h works
# properly. However, the package only uses autoconf and not automake,
# so we can't use the normal autoreconf logic.

SOCAT_DEPENDENCIES = host-autoconf

ifeq ($(BR2_PACKAGE_OPENSSL),y)
SOCAT_DEPENDENCIES += openssl
else
SOCAT_CONF_OPTS += --disable-openssl
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
SOCAT_DEPENDENCIES += readline
else
SOCAT_CONF_OPTS += --disable-readline
endif

define SOCAT_RUN_AUTOCONF
	(cd $(@D); $(HOST_DIR)/bin/autoconf)
endef

SOCAT_PRE_CONFIGURE_HOOKS += SOCAT_RUN_AUTOCONF

$(eval $(autotools-package))
