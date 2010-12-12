#############################################################
#
# input-tools
#
#############################################################
INPUT_TOOLS_VERSION = 20051019
INPUT_TOOLS_SOURCE  = joystick_$(INPUT_TOOLS_VERSION).orig.tar.gz
INPUT_TOOLS_PATCH   = joystick_$(INPUT_TOOLS_VERSION)-5.diff.gz
INPUT_TOOLS_SITE    = $(BR2_DEBIAN_MIRROR)/debian/pool/main/j/joystick/

INPUT_TOOLS_TARGETS_$(BR2_PACKAGE_INPUT_TOOLS_EVTEST)      += evtest
INPUT_TOOLS_TARGETS_$(BR2_PACKAGE_INPUT_TOOLS_INPUTATTACH) += inputattach
INPUT_TOOLS_TARGETS_$(BR2_PACKAGE_INPUT_TOOLS_JSCAL)       += jscal
INPUT_TOOLS_TARGETS_$(BR2_PACKAGE_INPUT_TOOLS_JSTEST)      += jstest

define INPUT_TOOLS_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef

INPUT_TOOLS_POST_PATCH_HOOKS = INPUT_TOOLS_DEBIAN_PATCHES

define INPUT_TOOLS_BUILD_CMDS
	(cd $(@D)/utils; \
		$(TARGET_CC) $(TARGET_CFLAGS) -o evtest evtest.c; \
		$(TARGET_CC) $(TARGET_CFLAGS) -o inputattach inputattach.c; \
		$(TARGET_CC) $(TARGET_CFLAGS) -o jscal jscal.c; \
		$(TARGET_CC) $(TARGET_CFLAGS) -o jstest jstest.c; \
	)
endef

define INPUT_TOOLS_INSTALL_TARGET_CMDS
	test -z "$(INPUT_TOOLS_TARGETS_y)" || \
	install -m 755 $(addprefix $(@D)/utils/,$(INPUT_TOOLS_TARGETS_y)) $(TARGET_DIR)/usr/bin/
endef

define INPUT_TOOLS_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,$(INPUT_TOOLS_TARGETS_y))
endef

define INPUT_TOOLS_CLEAN_CMDS
	rm -f $(addprefix $(@D)/utils/,$(INPUT_TOOLS_TARGETS_y))
endef

$(eval $(call GENTARGETS,package,input-tools))
