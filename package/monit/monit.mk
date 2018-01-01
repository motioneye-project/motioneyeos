################################################################################
#
# monit
#
################################################################################

MONIT_VERSION = 5.24.0
MONIT_SITE = http://mmonit.com/monit/dist
MONIT_LICENSE = AGPL-3.0 with OpenSSL exception
MONIT_LICENSE_FILES = COPYING
#
# Touching Makefile.am:
MONIT_AUTORECONF = YES

MONIT_CONF_ENV = \
	libmonit_cv_setjmp_available=yes \
	libmonit_cv_vsnprintf_c99_conformant=yes

MONIT_CONF_OPTS += \
	--without-pam \
	--with-largefiles

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MONIT_CONF_OPTS += --with-ssl=$(STAGING_DIR)/usr
MONIT_DEPENDENCIES += openssl
else
MONIT_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
MONIT_CONF_OPTS += --with-zlib
MONIT_DEPENDENCIES += zlib
else
MONIT_CONF_OPTS += --without-zlib
endif

$(eval $(autotools-package))
