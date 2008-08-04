#############################################################
#
# popt
#
#############################################################
POPT_VERSION = 1.14
POPT_SITE = http://rpm5.org/files/popt
POPT_INSTALL_STAGING = YES


POPT_CONF_ENV = ac_cv_va_copy=yes


POPT_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(REAL_GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --prefix=/usr

POPT_INSTALL_TARGET_OPT=DESTDIR=$(TARGET_DIR) install


$(eval $(call AUTOTARGETS,package,popt))
