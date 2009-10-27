#############################################################
#
# libart
#
#############################################################

LIBART_VERSION = 2.3.20
LIBART_SOURCE = libart_lgpl-$(LIBART_VERSION).tar.gz
LIBART_SITE = http://ftp.gnome.org/pub/gnome/sources/libart_lgpl/2.3/
LIBART_AUTORECONF = YES
LIBART_STAGING = YES
LIBART_TARGET = YES

$(eval $(call AUTOTARGETS,package,libart))
