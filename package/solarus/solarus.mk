################################################################################
#
# solarus
#
################################################################################

SOLARUS_VERSION = 1.6.0
SOLARUS_SITE = http://www.solarus-games.org/downloads/solarus
SOLARUS_SOURCE = solarus-$(SOLARUS_VERSION)-src.tar.gz

SOLARUS_LICENSE = GPL-3.0 (code), CC-BY-SA-4.0 (Solarus logos and icons), \
	CC-BY-SA-3.0 (GUI icons)
SOLARUS_LICENSE_FILES = license.txt

# Install libsolarus.so
SOLARUS_INSTALL_STAGING = YES

SOLARUS_DEPENDENCIES = libgl libmodplug libogg libvorbis luajit openal physfs sdl2 \
	sdl2_image sdl2_ttf

# Disable launcher GUI (requires Qt5)
SOLARUS_CONF_OPTS = -DSOLARUS_GUI=OFF

$(eval $(cmake-package))
