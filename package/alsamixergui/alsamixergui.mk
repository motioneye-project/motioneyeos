################################################################################
#
# alsamixergui
#
################################################################################

ALSAMIXERGUI_VERSION = 0.9.0rc2-1
ALSAMIXERGUI_SOURCE = alsamixergui_$(ALSAMIXERGUI_VERSION).orig.tar.gz
ALSAMIXERGUI_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/a/alsamixergui
ALSAMIXERGUI_LICENSE = GPL-2.0+
ALSAMIXERGUI_LICENSE_FILES = debian/copyright
ALSAMIXERGUI_AUTORECONF = YES

ALSAMIXERGUI_DEPENDENCIES = fltk alsa-lib

$(eval $(autotools-package))
