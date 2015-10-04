################################################################################
#
# sigrok-cli
#
################################################################################

SIGROK_CLI_VERSION = c59bf72b694ab1d08b2ea44de4349c277e206414
# No https access on upstream git
SIGROK_CLI_SITE = git://sigrok.org/sigrok-cli
SIGROK_CLI_LICENSE = GPLv3+
SIGROK_CLI_LICENSE_FILES = COPYING
# Git checkout has no configure script
SIGROK_CLI_AUTORECONF = YES
SIGROK_CLI_DEPENDENCIES = host-pkgconf libsigrok

ifeq ($(BR2_PACKAGE_LIBSIGROKDECODE),y)
SIGROK_CLI_CONF_OPTS += --with-libsigrokdecode
SIGROK_CLI_DEPENDENCIES += libsigrokdecode
else
SIGROK_CLI_CONF_OPTS += --with-libsigrokdecode=NO
endif

define SIGROK_CLI_ADD_MISSING
	mkdir -p $(@D)/autostuff
endef

SIGROK_CLI_PRE_CONFIGURE_HOOKS += SIGROK_CLI_ADD_MISSING

$(eval $(autotools-package))
