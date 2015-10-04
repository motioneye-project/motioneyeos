################################################################################
#
# python-pygame
#
################################################################################

# stable 1.9.1 release requires V4L which has been wiped out of recent Linux
# kernels, so use latest mercurial revision until next stable release is out.
PYTHON_PYGAME_VERSION = f0bb4a4b365d
PYTHON_PYGAME_SOURCE = pygame-$(PYTHON_PYGAME_VERSION).tar.gz
PYTHON_PYGAME_SITE = https://bitbucket.org/pygame/pygame
PYTHON_PYGAME_SITE_METHOD = hg
PYTHON_PYGAME_SETUP_TYPE = distutils
PYTHON_PYGAME_LICENSE = LGPLv2.1+
PYTHON_PYGAME_LICENSE_FILES = LGPL

ifeq ($(BR2_PACKAGE_PYTHON_PYGAME_IMAGE),y)
PYTHON_PYGAME_OPT_DEPENDS += sdl_image
endif

ifeq ($(BR2_PACKAGE_PYTHON_PYGAME_FONT),y)
PYTHON_PYGAME_OPT_DEPENDS += sdl_ttf
endif

ifeq ($(BR2_PACKAGE_PYTHON_PYGAME_MIXER),y)
PYTHON_PYGAME_OPT_DEPENDS += sdl_mixer
endif

PYTHON_PYGAME_DEPENDENCIES = sdl $(PYTHON_PYGAME_OPT_DEPENDS)

ifneq ($(BR2_PACKAGE_PYTHON_PYGAME_IMAGE),y)
define PYTHON_PYGAME_UNCONFIGURE_IMAGE
	$(SED) 's/^imageext/#imageext/' $(@D)/Setup
endef
endif

ifneq ($(BR2_PACKAGE_PYTHON_PYGAME_FONT),y)
define PYTHON_PYGAME_UNCONFIGURE_FONT
	$(SED) 's/^font/#font/' $(@D)/Setup
endef
endif

ifneq ($(BR2_PACKAGE_PYTHON_PYGAME_MIXER),y)
define PYTHON_PYGAME_UNCONFIGURE_MIXER
	$(SED) 's/^mixer/#mixer/g' $(@D)/Setup
endef
endif

# Both require numpy or numeric python module
define PYTHON_PYGAME_UNCONFIGURE_SNDARRAY
	$(SED) 's/^_numericsndarray/#_numericsndarray/' $(@D)/Setup
endef

define PYTHON_PYGAME_UNCONFIGURE_SURFARRAY
	$(SED) 's/^_numericsurfarray/#_numericsurfarray/' $(@D)/Setup
endef

# Requires smpeg
define PYTHON_PYGAME_UNCONFIGURE_MOVIE
	$(SED) 's/^movie/#movie/' $(@D)/Setup
endef

ifneq ($(BR2_PACKAGE_PYTHON_PYGAME_SCRAP),y)
define PYTHON_PYGAME_UNCONFIGURE_SCRAP
	$(SED) 's/^scrap/#scrap/' $(@D)/Setup
endef
endif

PYTHON_PYGAME_SDL_FLAGS = `$(STAGING_DIR)/usr/bin/sdl-config --cflags`
PYTHON_PYGAME_SDL_FLAGS += `$(STAGING_DIR)/usr/bin/sdl-config --libs`

# Pygame needs a Setup file where options should be commented out if
# dependencies are not available
define PYTHON_PYGAME_CONFIGURE_CMDS
	cp -f $(@D)/Setup.in $(@D)/Setup
	$(SED) "s~^SDL = ~SDL = $(PYTHON_PYGAME_SDL_FLAGS) \n#~" $(@D)/Setup
	$(SED) 's/^pypm/#pypm/' $(@D)/Setup
	$(PYTHON_PYGAME_UNCONFIGURE_IMAGE)
	$(PYTHON_PYGAME_UNCONFIGURE_FONT)
	$(PYTHON_PYGAME_UNCONFIGURE_MIXER)
	$(PYTHON_PYGAME_UNCONFIGURE_SNDARRAY)
	$(PYTHON_PYGAME_UNCONFIGURE_SURFARRAY)
	$(PYTHON_PYGAME_UNCONFIGURE_MOVIE)
	$(PYTHON_PYGAME_UNCONFIGURE_SCRAP)
endef

define PYTHON_PYGAME_REMOVE_DOC
	rm -rf $(TARGET_DIR)/usr/lib/python*/site-packages/pygame/docs
endef

PYTHON_PYGAME_POST_INSTALL_TARGET_HOOKS += PYTHON_PYGAME_REMOVE_DOC

define PYTHON_PYGAME_REMOVE_TESTS
	rm -rf $(TARGET_DIR)/usr/lib/python*/site-packages/pygame/tests
endef

PYTHON_PYGAME_POST_INSTALL_TARGET_HOOKS += PYTHON_PYGAME_REMOVE_TESTS

ifneq ($(BR2_PACKAGE_PYTHON_PYGAME_EXAMPLES),y)
define PYTHON_PYGAME_REMOVE_EXAMPLES
	rm -rf $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages/pygame/examples
endef
PYTHON_PYGAME_POST_INSTALL_TARGET_HOOKS += PYTHON_PYGAME_REMOVE_EXAMPLES
endif

$(eval $(python-package))
