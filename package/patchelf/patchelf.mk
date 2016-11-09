################################################################################
#
# patchelf
#
################################################################################

PATCHELF_VERSION = 0.9
PATCHELF_SITE = http://releases.nixos.org/patchelf/patchelf-0.9
PATCHELF_LICENSE = GPLv3+
PATCHELF_LICENSE_FILES = COPYING

$(eval $(host-autotools-package))
