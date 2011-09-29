#############################################################
#
# lzo
#
#############################################################
LZO_VERSION = 2.06
LZO_SITE = http://www.oberhumer.com/opensource/lzo/download
LZO_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
