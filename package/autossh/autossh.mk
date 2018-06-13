################################################################################
#
# autossh
#
################################################################################

AUTOSSH_VERSION = 1.4f
AUTOSSH_SITE = http://www.harding.motd.ca/autossh
AUTOSSH_SOURCE = autossh-$(AUTOSSH_VERSION).tgz
AUTOSSH_LICENSE = Modified BSD
AUTOSSH_LICENSE_FILES = autossh.c

AUTOSSH_CONF_OPTS = --with-ssh=/usr/bin/ssh

$(eval $(autotools-package))
