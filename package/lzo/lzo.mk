#############################################################
#
# lzo
#
#############################################################
LZO_VERSION:=2.03
LZO_SOURCE:=lzo-$(LZO_VERSION).tar.gz
LZO_SITE:=http://www.oberhumer.com/opensource/lzo/download
LZO_AUTORECONF = NO
LZO_INSTALL_STAGING = YES
LZO_INSTALL_TARGET = YES
LZO_INSTALL_STAGING_OPT = CC="$(TARGET_CC)" DESTDIR=$(STAGING_DIR) install
LZO_CONF_ENV =
LZO_CONF_OPT =
LZO_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,lzo))
