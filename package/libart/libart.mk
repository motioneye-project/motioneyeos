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

LIBART_CONF_OPT = --target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) --build=$(GNU_HOST_NAME) \
		--prefix=/usr --sysconfdir=/etc

LIBART_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,libart))
