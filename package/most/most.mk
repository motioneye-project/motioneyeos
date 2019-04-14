################################################################################
#
# most
#
################################################################################

MOST_SITE = http://www.jedsoft.org/releases/most
MOST_VERSION = 5.1.0
MOST_LICENSE = GPL-2.0+
MOST_LICENSE_FILES = COPYING COPYRIGHT
MOST_DEPENDENCIES = slang

MOST_CONF_OPTS = --with-slang=$(STAGING_DIR)/usr
MOST_MAKE = $(MAKE1)

define MOST_REMOVE_LOCAL_SLANG_CHECK
	$(SED) 's/ slangversion / /g' $(@D)/src/Makefile.in
endef
MOST_POST_PATCH_HOOKS += MOST_REMOVE_LOCAL_SLANG_CHECK

define MOST_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/objs/most $(TARGET_DIR)/usr/bin/most
endef

$(eval $(autotools-package))
