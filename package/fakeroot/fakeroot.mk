#############################################################
#
# fakeroot
#
#############################################################
FAKEROOT_VERSION:=1.9.5
FAKEROOT_SOURCE:=fakeroot_$(FAKEROOT_VERSION).tar.gz
FAKEROOT_SITE:=http://snapshot.debian.org/archive/debian/20080427T000000Z/pool/main/f/fakeroot/

define FAKEROOT_PATCH_FAKEROOT_IN
	# If using busybox getopt, make it be quiet.
	$(SED) "s,getopt --version,getopt --version 2>/dev/null," \
		$(@D)/scripts/fakeroot.in
endef

FAKEROOT_POST_PATCH_HOOKS += FAKEROOT_PATCH_FAKEROOT_IN

define FAKEROOT_RENAME_TARGET_BINARIES
	-mv $(TARGET_DIR)/usr/bin/$(ARCH)-*-faked \
		$(TARGET_DIR)/usr/bin/faked
	-mv $(TARGET_DIR)/usr/bin/$(ARCH)-*-fakeroot \
		$(TARGET_DIR)/usr/bin/fakeroot
endef

FAKEROOT_POST_INSTALL_TARGET_HOOKS += FAKEROOT_RENAME_TARGET_BINARIES

$(eval $(call AUTOTARGETS,package,fakeroot))
$(eval $(call AUTOTARGETS,package,fakeroot,host))
