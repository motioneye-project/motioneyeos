################################################################################
#
# popt
#
################################################################################

POPT_VERSION = 1.16
POPT_SITE = http://rpm5.org/files/popt
POPT_INSTALL_STAGING = YES
POPT_LICENSE = MIT
POPT_LICENSE_FILES = COPYING
POPT_AUTORECONF = YES
POPT_GETTEXTIZE = YES

ifeq ($(BR2_PACKAGE_GETTEXT),y)
POPT_DEPENDENCIES += gettext
endif

POPT_CONF_ENV = ac_cv_va_copy=yes

ifeq ($(BR2_PACKAGE_LIBICONV),y)
POPT_CONF_ENV += am_cv_lib_iconv=yes
POPT_CONF_OPTS += --with-libiconv-prefix=$(STAGING_DIR)/usr
POPT_DEPENDENCIES += libiconv
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
