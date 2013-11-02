################################################################################
#
# a10disp
#
################################################################################

A10DISP_VERSION = a899cc6dcf909360aac00482ede5369f3656f226
A10DISP_SITE = http://github.com/hglm/a10disp/tarball/$(A10DISP_VERSION)
A10DISP_LICENSE = MIT

A10DISP_DEPENDENCIES = linux

define A10DISP_BUILD_CMDS
	cp -f $(LINUX_DIR)/include/video/sunxi_disp_ioctl.h $(@D)/
	$(TARGET_CC) $(TARGET_CFLAGS) $(@D)/a10disp.c -o $(@D)/a10disp
endef

define A10DISP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/a10disp $(TARGET_DIR)/usr/bin/a10disp
endef

$(eval $(generic-package))
