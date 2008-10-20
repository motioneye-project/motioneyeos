#############################################################
#
# popt
#
#############################################################
POPT_VERSION:=1.14
POPT_SITE:=http://rpm5.org/files/popt
POPT_INSTALL_STAGING:=YES
POPT_INSTALL_TARGET:=YES
POPT_CONF_ENV:=ac_cv_va_copy=yes

POPT_DEPENDENCIES:=uclibc

$(eval $(call AUTOTARGETS,package,popt))
