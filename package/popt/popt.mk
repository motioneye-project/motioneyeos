#############################################################
#
# popt
#
#############################################################
POPT_VERSION = 1.14
POPT_SITE = http://rpm5.org/files/popt
POPT_INSTALL_STAGING = YES

POPT_CONF_ENV = ac_cv_va_copy=yes

POPT_INSTALL_TARGET_OPT=DESTDIR=$(TARGET_DIR) install


$(eval $(call AUTOTARGETS,package,popt))
