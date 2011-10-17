#############################################################
#
# giblib
#
#############################################################
GIBLIB_VERSION = 1.2.4
GIBLIB_SOURCE = giblib-$(GIBLIB_VERSION).tar.gz
GIBLIB_SITE = http://linuxbrit.co.uk/downloads/
GIBLIB_INSTALL_STAGING = YES
GIBLIB_DEPENDENCIES = imlib2
GIBLIB_CONF_OPT = --with-imlib2-prefix=$(STAGING)/usr/lib \
		  --with-imlib2-exec-prefix=$(STAGING)/usr/bin

$(eval $(call AUTOTARGETS))
