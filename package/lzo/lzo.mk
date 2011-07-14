#############################################################
#
# lzo
#
#############################################################
LZO_VERSION = 2.05
LZO_SITE = http://www.oberhumer.com/opensource/lzo/download
LZO_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package,lzo))
$(eval $(call AUTOTARGETS,package,lzo,host))
