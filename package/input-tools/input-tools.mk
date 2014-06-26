################################################################################
#
# input-tools
#
################################################################################

INPUT_TOOLS_VERSION = 20051019
INPUT_TOOLS_SOURCE = joystick_$(INPUT_TOOLS_VERSION).orig.tar.gz
INPUT_TOOLS_PATCH = joystick_$(INPUT_TOOLS_VERSION)-5.diff.gz
INPUT_TOOLS_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/j/joystick/
INPUT_TOOLS_LICENSE = GPLv2+
INPUT_TOOLS_LICENSE_FILES = utils/Makefile

INPUT_TOOLS_TARGETS_$(BR2_PACKAGE_INPUT_TOOLS_INPUTATTACH) += inputattach
INPUT_TOOLS_TARGETS_$(BR2_PACKAGE_INPUT_TOOLS_JSCAL)       += jscal
INPUT_TOOLS_TARGETS_$(BR2_PACKAGE_INPUT_TOOLS_JSTEST)      += jstest

define INPUT_TOOLS_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		support/scripts/apply-patches.sh $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef

INPUT_TOOLS_POST_PATCH_HOOKS = INPUT_TOOLS_DEBIAN_PATCHES

# jscal needs -lm
define INPUT_TOOLS_BUILD_CMDS
	for i in $(filter-out jscal,$(INPUT_TOOLS_TARGETS_y)); do \
		$(TARGET_CC) $(TARGET_CFLAGS) -o $(@D)/$$i $(@D)/utils/$$i.c \
			$(TARGET_LDFLAGS); \
	done
	for i in $(filter jscal,$(INPUT_TOOLS_TARGETS_y)); do \
		$(TARGET_CC) $(TARGET_CFLAGS) -o $(@D)/$$i $(@D)/utils/$$i.c \
			$(TARGET_LDFLAGS) -lm; \
	done
endef

define INPUT_TOOLS_INSTALL_TARGET_CMDS
	for i in $(INPUT_TOOLS_TARGETS_y); do \
		$(INSTALL) -m 755 -D $(@D)/$$i $(TARGET_DIR)/usr/bin/$$i; \
	done
endef

$(eval $(generic-package))
