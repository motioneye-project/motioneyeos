################################################################################
#
# autossh
#
################################################################################

AUTOSSH_VERSION = 1.4e
AUTOSSH_SITE = http://www.harding.motd.ca/autossh
AUTOSSH_SOURCE = autossh-$(AUTOSSH_VERSION).tgz
AUTOSSH_LICENSE = Modified BSD
AUTOSSH_LICENSE_FILES = autossh.c

# Bundled ./configure is not up-to-date with what is in configure.ac
AUTOSSH_AUTORECONF = YES

AUTOSSH_CONF_OPTS = --with-ssh=/usr/bin/ssh

define AUTOSSH_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/autossh $(TARGET_DIR)/usr/bin/autossh
endef

$(eval $(autotools-package))
