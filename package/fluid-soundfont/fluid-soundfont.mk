################################################################################
#
# fluid-soundfont
#
################################################################################

FLUID_SOUNDFONT_VERSION = 3.1
FLUID_SOUNDFONT_SOURCE = fluid-soundfont_$(FLUID_SOUNDFONT_VERSION).orig.tar.gz
# The http://www.hammersound.net archive site seems unreliable (show HTTP 500
# error), and also publish the file in the sfArk format, which is inconvenient
# to be used in automated build. We use here the Debian mirror publishing the
# file in a more convenient format (inative sf2 in a tar.gz archive).
FLUID_SOUNDFONT_SITE = http://http.debian.net/debian/pool/main/f/fluid-soundfont
FLUID_SOUNDFONT_LICENSE = MIT
FLUID_SOUNDFONT_LICENSE_FILES = COPYING

define FLUID_SOUNDFONT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/FluidR3_GM.sf2 $(TARGET_DIR)/usr/share/soundfonts/FluidR3_GM.sf2
endef

$(eval $(generic-package))
