################################################################################
#
# zisofs-tools
#
################################################################################

ZISOFS_TOOLS_VERSION = 1.1.11
ZISOFS_TOOLS_SOURCE = cdrkit_$(ZISOFS_TOOLS_VERSION).orig.tar.gz
ZISOFS_TOOLS_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/c/cdrkit
ZISOFS_TOOLS_LICENSE = GPL-2.0+
ZISOFS_TOOLS_LICENSE_FILES = 3rd-party/zisofs_tools/COPYING
ZISOFS_TOOLS_SUBDIR = 3rd-party/zisofs_tools
HOST_ZISOFS_TOOLS_DEPENDENCIES = host-zlib

$(eval $(host-autotools-package))
