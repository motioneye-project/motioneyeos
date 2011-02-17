#############################################################
#
# popt
#
#############################################################
POPT_VERSION:=1.15
POPT_SITE:=http://rpm5.org/files/popt
POPT_INSTALL_STAGING = YES
POPT_INSTALL_TARGET = YES


POPT_CONF_ENV = ac_cv_va_copy=yes

ifeq ($(BR2_PACKAGE_LIBICONV),y)
POPT_CONF_ENV += am_cv_lib_iconv=yes
POPT_CONF_OPT += --with-libiconv-prefix=$(STAGING_DIR)/usr
endif

$(eval $(call AUTOTARGETS,package,popt))
