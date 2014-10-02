################################################################################
#
# autossh
#
################################################################################

AUTOSSH_VERSION = 1.4d
AUTOSSH_SITE = http://www.harding.motd.ca/autossh
AUTOSSH_SOURCE = autossh-$(AUTOSSH_VERSION).tgz
AUTOSSH_LICENSE = Modified BSD
AUTOSSH_LICENSE_FILES = autossh.c

define AUTOSSH_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/autossh $(TARGET_DIR)/usr/bin/autossh
endef

$(eval $(autotools-package))
