#############################################################
#
# tar
#
#############################################################
TAR_VERSION:=1.21
TAR_SOURCE:=tar-$(TAR_VERSION).tar.bz2
TAR_SITE:=$(BR2_GNU_MIRROR)/tar/

$(eval $(call AUTOTARGETS,package,tar))
