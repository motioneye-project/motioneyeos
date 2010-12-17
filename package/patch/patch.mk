#############################################################
#
# patch
#
#############################################################

PATCH_VERSION = 2.6
PATCH_SITE = $(BR2_GNU_MIRROR)/patch

$(eval $(call AUTOTARGETS,package,patch))
