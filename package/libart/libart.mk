################################################################################
#
# libart
#
################################################################################

LIBART_VERSION_MAJOR = 2.3
LIBART_VERSION = $(LIBART_VERSION_MAJOR).21
LIBART_SOURCE = libart_lgpl-$(LIBART_VERSION).tar.gz
LIBART_SITE = http://ftp.gnome.org/pub/gnome/sources/libart_lgpl/$(LIBART_VERSION_MAJOR)/
LIBART_AUTORECONF = YES
LIBART_INSTALL_STAGING = YES
LIBART_CONFIG_SCRIPTS = libart2-config

$(eval $(autotools-package))
