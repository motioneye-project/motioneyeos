################################################################################
#
# solarus
#
################################################################################

SOLARUS_VERSION = v1.5.3
SOLARUS_SITE = $(call github,solarus-games,solarus,$(SOLARUS_VERSION))

SOLARUS_LICENSE = GPL-3.0 (code), CC-BY-SA-4.0 (Solarus logos and icons), \
	CC-BY-SA-3.0 (GUI icons)
SOLARUS_LICENSE_FILES = license.txt license_gpl.txt

# Install libsolarus.so
SOLARUS_INSTALL_STAGING = YES

SOLARUS_DEPENDENCIES = libmodplug libogg libvorbis luajit openal physfs sdl2 \
	sdl2_image sdl2_ttf

# Disable launcher GUI (requires Qt5)
SOLARUS_CONF_OPTS = -DSOLARUS_GUI=OFF

$(eval $(cmake-package))
