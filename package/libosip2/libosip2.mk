#############################################################
#
# libosip2
#
#############################################################
LIBOSIP2_VERSION=3.1.0
LIBOSIP2_SOURCE=libosip2-$(LIBOSIP2_VERSION).tar.gz
LIBOSIP2_SITE=http://www.antisip.com/download/exosip2
LIBOSIP2_INSTALL_STAGING=YES

LIBOSIP2_CONF_OPT = \
	--with-gnu-ld \
	--enable-shared \
	--enable-static

$(eval $(call AUTOTARGETS,package,libosip2))
