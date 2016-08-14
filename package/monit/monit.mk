################################################################################
#
# monit
#
################################################################################

MONIT_VERSION = 5.17
MONIT_SITE = http://mmonit.com/monit/dist
MONIT_LICENSE = AGPLv3 with OpenSSL exception
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

$(eval $(autotools-package))
