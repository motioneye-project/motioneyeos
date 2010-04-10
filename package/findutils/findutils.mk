#############################################################
#
# findutils
#
#############################################################
FINDUTILS_VERSION:=4.2.31
FINDUTILS_SOURCE:=findutils-$(FINDUTILS_VERSION).tar.gz
FINDUTILS_SITE:=$(BR2_GNU_MIRROR)/findutils/

$(eval $(call AUTOTARGETS,package,findutils))
