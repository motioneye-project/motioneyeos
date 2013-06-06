################################################################################
#
# omap-u-boot-utils
#
################################################################################

OMAP_U_BOOT_UTILS_VERSION = 8aff852
OMAP_U_BOOT_UTILS_SITE = http://github.com/nmenon/omap-u-boot-utils/tarball/$(OMAP_U_BOOT_UTILS_VERSION)
OMAP_U_BOOT_UTILS_LICENSE = GPLv2, GPLv2+
OMAP_U_BOOT_UTILS_LICENSE_FILES = COPYING

define HOST_OMAP_U_BOOT_UTILS_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define HOST_OMAP_U_BOOT_UTILS_INSTALL_CMDS
	for f in gpsign pserial tagger ucmd ukermit ; do \
		install -m 755 -D $(@D)/$$f $(HOST_DIR)/usr/bin/$$f ; \
	done
endef

$(eval $(host-generic-package))
