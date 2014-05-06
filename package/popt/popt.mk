################################################################################
#
# popt
#
################################################################################

POPT_VERSION = 1.16
# rpm5.org down
POPT_SITE = http://anduin.linuxfromscratch.org/sources/BLFS/svn/p/
POPT_INSTALL_STAGING = YES
POPT_LICENSE = MIT
POPT_LICENSE_FILES = COPYING

POPT_CONF_ENV = ac_cv_va_copy=yes

# The external Blackfin toolchains have <glob.h>, but not all the
# necessary uClibc options for glob functions, so we force disable the
# usage of the glob functions for these toolchains.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_2012R1)$(BR2_TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_2012R2)$(BR2_TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_2013R1),y)
POPT_CONF_ENV += ac_cv_header_glob_h=no
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
POPT_CONF_ENV += am_cv_lib_iconv=yes
POPT_CONF_OPT += --with-libiconv-prefix=$(STAGING_DIR)/usr
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
