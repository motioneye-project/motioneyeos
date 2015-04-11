################################################################################
#
# bitstream-vera
#
################################################################################

BITSTREAM_VERA_VERSION = 1.10
BITSTREAM_VERA_SITE = http://ftp.gnome.org/pub/GNOME/sources/ttf-bitstream-vera/$(BITSTREAM_VERA_VERSION)
BITSTREAM_VERA_SOURCE = ttf-bitstream-vera-$(BITSTREAM_VERA_VERSION).tar.bz2
BITSTREAM_VERA_TARGET_DIR = $(TARGET_DIR)/usr/share/fonts/ttf-bitstream-vera
BITSTREAM_VERA_LICENSE = BitstreamVera
BITSTREAM_VERA_LICENSE_FILES = COPYRIGHT.TXT

define BITSTREAM_VERA_INSTALL_TARGET_CMDS
	mkdir -p $(BITSTREAM_VERA_TARGET_DIR)
	$(INSTALL) -m 644 $(@D)/*.ttf $(BITSTREAM_VERA_TARGET_DIR)
endef

$(eval $(generic-package))
