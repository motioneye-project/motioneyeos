################################################################################
#
# memtest86
#
################################################################################

MEMTEST86_VERSION = 5.01
MEMTEST86_SOURCE = memtest86+-$(MEMTEST86_VERSION).tar.gz
MEMTEST86_SITE = http://www.memtest.org/download/$(MEMTEST86_VERSION)
MEMTEST86_LICENSE = GPLv2
MEMTEST86_LICENSE_FILES = README

# memtest86+ is sensitive to toolchain changes, use the shipped binary version
define MEMTEST86_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/precomp.bin $(TARGET_DIR)/boot/memtest86+.bin
endef

$(eval $(generic-package))
