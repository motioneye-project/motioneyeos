################################################################################
#
# ASCII-Invaders
#
################################################################################

ASCII_INVADERS_VERSION = 1.0.1
ASCII_INVADERS_SITE = $(call github,macdice,ascii-invaders,v$(ASCII_INVADERS_VERSION))
ASCII_INVADERS_DEPENDENCIES = ncurses
ASCII_INVADERS_LICENSE = GPL-2.0+
ASCII_INVADERS_LICENSE_FILES = LICENSE

# For compiling statically, libraries must be specified after the object file
define ASCII_INVADERS_POST_EXTRACT_FIXUP
	sed -i 's/\$$(LIBS) invaders.o/invaders.o \$$(LIBS)/' $(@D)/Makefile
endef
ASCII_INVADERS_POST_EXTRACT_HOOKS += ASCII_INVADERS_POST_EXTRACT_FIXUP

define ASCII_INVADERS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define ASCII_INVADERS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/ascii_invaders $(TARGET_DIR)/usr/bin/ascii_invaders
endef

$(eval $(generic-package))
