#############################################################
#
# lzop
#
#############################################################
LZOP_VERSION = 1.03
LZOP_SOURCE = lzop-$(LZOP_VERSION).tar.gz
LZOP_SITE = http://www.lzop.org/download/
LZOP_DEPENDENCIES = lzo

$(eval $(call AUTOTARGETS))
