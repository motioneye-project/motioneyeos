################################################################################
#
# libsoil
#
################################################################################

LIBSOIL_VERSION = 20080707
LIBSOIL_SOURCE = soil.zip
LIBSOIL_SITE = http://www.lonesock.net/files
LIBSOIL_INSTALL_STAGING = YES
LIBSOIL_DEPENDENCIES = libgl
LIBSOIL_LICENSE = Public Domain, MIT
LIBSOIL_LICENSE_FILES = src/stb_image_aug.c src/image_helper.c
LIBSOIL_MAKEFILE = ../projects/makefile/alternate_Makefile.txt

define LIBSOIL_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(LIBSOIL_DL_DIR)/$(LIBSOIL_SOURCE)
	mv $(@D)/Simple\ OpenGL\ Image\ Library/* $(@D)
endef

# gnu patch < v2.5.9 doesn't correctly handle spaces in file names,
# and we want to patch the 'alternate Makefile.txt' file, so rename
# the file (and patch the renamed file) for compatibility with older
# distributions
define REMOVE_SPACE_FROM_FILENAME
	cd $(@D)/projects/makefile/ && \
		mv "alternate Makefile.txt" alternate_Makefile.txt
endef
LIBSOIL_POST_EXTRACT_HOOKS += REMOVE_SPACE_FROM_FILENAME

define LIBSOIL_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -f $(LIBSOIL_MAKEFILE) \
		-C $(@D)/src
endef

define LIBSOIL_INSTALL_STAGING_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -f $(LIBSOIL_MAKEFILE) \
		DESTDIR=$(STAGING_DIR) install \
		INSTALL=$(INSTALL) \
		-C $(@D)/src
endef

define LIBSOIL_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -f $(LIBSOIL_MAKEFILE) \
		DESTDIR=$(TARGET_DIR) install \
		INSTALL=$(INSTALL) \
		-C $(@D)/src
endef

$(eval $(generic-package))
