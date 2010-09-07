#############################################################
#
# patch
#
#############################################################
PATCH_VERSION:=2.6
PATCH_SOURCE:=patch_$(PATCH_VERSION).orig.tar.gz
PATCH_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/p/patch

$(eval $(call AUTOTARGETS,package,patch))
