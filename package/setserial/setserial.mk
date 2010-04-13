#############################################################
#
# Setserial
#
#############################################################
SETSERIAL_VERSION:=2.17
SETSERIAL_PATCH_VERSION:=.orig
SETSERIAL_PATCH_FILE:=setserial_2.17-45.diff.gz
SETSERIAL_SOURCE:=setserial_$(SETSERIAL_VERSION)$(SETSERIAL_PATCH_VERSION).tar.gz
SETSERIAL_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/s/setserial/
SETSERIAL_INSTALL_TARGET_OPT=DESTDIR=$(TARGET_DIR) install

define SETSERIAL_APPLY_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef

SETSERIAL_POST_PATCH_HOOKS += SETSERIAL_APPLY_DEBIAN_PATCHES

$(eval $(call AUTOTARGETS,package,setserial))
