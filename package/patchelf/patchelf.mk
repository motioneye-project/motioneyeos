################################################################################
#
# patchelf
#
################################################################################

PATCHELF_VERSION = 0.9
PATCHELF_SITE = http://releases.nixos.org/patchelf/patchelf-$(PATCHELF_VERSION)
PATCHELF_SOURCE = patchelf-$(PATCHELF_VERSION).tar.bz2
PATCHELF_LICENSE = GPL-3.0+
PATCHELF_LICENSE_FILES = COPYING

$(eval $(host-autotools-package))
