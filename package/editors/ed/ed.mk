#############################################################
#
# ed
#
#############################################################
ED_VERSION:=1.1
ED_SOURCE:=ed-$(ED_VERSION).tar.bz2
ED_SITE:=$(BR2_GNU_MIRROR)/ed/

$(eval $(call AUTOTARGETS,package/editors,ed))
