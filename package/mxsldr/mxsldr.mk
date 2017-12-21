################################################################################
#
# mxsldr
#
################################################################################

MXSLDR_VERSION = 2793a657ab7a22487d21c1b020957806f8ae8383
MXSLDR_SITE = git://git.denx.de/mxsldr.git
MXSLDR_LICENSE = GPL-2.0+
MXSLDR_LICENSE_FILES = COPYING
HOST_MXSLDR_DEPENDENCIES = host-libusb host-pkgconf

define HOST_MXSLDR_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define HOST_MXSLDR_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/mxsldr $(HOST_DIR)/bin/mxsldr
endef

$(eval $(host-generic-package))
