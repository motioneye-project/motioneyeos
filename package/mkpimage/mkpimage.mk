################################################################################
#
# mkpimage
#
################################################################################

# source included in the package
# came from barebox's repository:
# http://git.pengutronix.de/?p=barebox.git;a=blob;f=scripts/socfpga_mkimage.c;h=1a7a66d98841e9f52c3ea49c651286aa1412c9a5;hb=HEAD
HOST_MKPIMAGE_LICENSE = GPLv2

define HOST_MKPIMAGE_BUILD_CMDS
	$(HOSTCC) $(HOST_CFLAGS) $(HOST_LDFLAGS) \
		package/mkpimage/mkpimage.c -o $(@D)/mkpimage
endef

define HOST_MKPIMAGE_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/mkpimage $(HOST_DIR)/usr/bin/mkpimage
endef

$(eval $(host-generic-package))
