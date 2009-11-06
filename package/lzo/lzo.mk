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

$(eval $(call AUTOTARGETS,package,lzo))
$(eval $(call AUTOTARGETS,package,lzo,host))
