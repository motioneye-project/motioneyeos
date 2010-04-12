#############################################################
#
# patch
#
#############################################################
PATCH_VERSION:=2.6
PATCH_SOURCE:=patch_$(PATCH_VERSION).orig.tar.gz
PATCH_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/p/patch
PATCH_INSTALL_TARGET_OPT=DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package,patch))
