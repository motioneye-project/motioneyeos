################################################################################
#
# fbdump
#
################################################################################

FBDUMP_VERSION = 0.4.2
FBDUMP_SOURCE = fbdump-$(FBDUMP_VERSION).tar.gz
FBDUMP_SITE = http://www.rcdrummond.net/fbdump
FBDUMP_LICENSE = GPLv2
FBDUMP_LICENSE_FILES = COPYING

# The VGA16 specific feature of fbdump doesn't make much sense outside
# of the x86/x86-64 architectures, and causes build problems on some
# architectures as outw() is not always available.
ifeq ($(BR2_i386)$(BR2_x86_64),y)
FBDUMP_CONF_OPT += --enable-vga16fb
else
FBDUMP_CONF_OPT += --disable-vga16fb
endif

$(eval $(autotools-package))
