################################################################################
#
# socat
#
################################################################################

SOCAT_VERSION = 1.7.3.4
SOCAT_SOURCE = socat-$(SOCAT_VERSION).tar.bz2
SOCAT_SITE = http://www.dest-unreach.org/socat/download
SOCAT_LICENSE = GPL-2.0 with OpenSSL exception
SOCAT_LICENSE_FILES = README COPYING COPYING.OpenSSL

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

# We need to run autoconf to regenerate the configure script, since we patch
# configure.in and Makefile.in. However, the package only uses autoconf and not
# automake, so we can't use the normal autoreconf logic.

SOCAT_DEPENDENCIES = host-autoconf
# incompatibile license (GPL-3.0+)
SOCAT_CONF_OPTS = --disable-readline

ifeq ($(BR2_PACKAGE_OPENSSL),y)
SOCAT_DEPENDENCIES += openssl
else
SOCAT_CONF_OPTS += --disable-openssl
endif

define SOCAT_RUN_AUTOCONF
	(cd $(@D); $(AUTOCONF))
endef

SOCAT_PRE_CONFIGURE_HOOKS += SOCAT_RUN_AUTOCONF

$(eval $(autotools-package))
