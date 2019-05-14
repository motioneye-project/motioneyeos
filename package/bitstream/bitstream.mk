################################################################################
#
# bitstream
#
################################################################################

BITSTREAM_VERSION = 1.4
BITSTREAM_SOURCE = bitstream-$(BITSTREAM_VERSION).tar.bz2
BITSTREAM_SITE = https://get.videolan.org/bitstream/$(BITSTREAM_VERSION)
BITSTREAM_LICENSE = MIT
BITSTREAM_LICENSE_FILES = COPYING

# package consists of header files only
BITSTREAM_INSTALL_STAGING = YES
BITSTREAM_INSTALL_TARGET = NO

define BITSTREAM_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) PREFIX=/usr install
endef

$(eval $(generic-package))
