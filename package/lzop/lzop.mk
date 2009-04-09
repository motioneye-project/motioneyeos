#############################################################
#
# lzop
#
#############################################################
LZOP_VERSION:=1.02rc1
LZOP_SOURCE:=lzop-$(LZOP_VERSION).tar.gz
LZOP_SITE:=http://www.lzop.org/download/
LZOP_CONF_OPT:=--program-prefix=""
LZOP_DEPENDENCIES:=lzo

$(eval $(call AUTOTARGETS,package,lzop))
