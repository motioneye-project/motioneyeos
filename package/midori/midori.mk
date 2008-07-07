#############################################################
#
# midori
#
#############################################################

MIDORI_VERSION = 0.0.18
MIDORI_SOURCE = midori-$(MIDORI_VERSION).tar.gz
MIDORI_SITE = http://software.twotoasts.de/media/midori/
MIDORI_AUTORECONF = YES
MIDORI_INSTALL_STAGING = NO
MIDORI_INSTALL_TARGET = YES

MIDORI_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME)  --prefix=/usr --sysconfdir=/etc \
		PKG_CONFIG_PATH=$(STAGING_DIR)/usr/lib/pkgconfig


MIDORI_DEPENDENCIES = uclibc pkgconfig webkit libsexy $(XSERVER)

$(eval $(call AUTOTARGETS,package,midori))
