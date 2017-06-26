################################################################################
#
# sigrok-cli
#
################################################################################

SIGROK_CLI_VERSION = 0.7.0
SIGROK_CLI_SITE = http://sigrok.org/download/source/sigrok-cli
SIGROK_CLI_LICENSE = GPL-3.0+
SIGROK_CLI_LICENSE_FILES = COPYING
SIGROK_CLI_DEPENDENCIES = host-pkgconf libsigrok

ifeq ($(BR2_PACKAGE_LIBSIGROKDECODE),y)
SIGROK_CLI_CONF_OPTS += --with-libsigrokdecode
SIGROK_CLI_DEPENDENCIES += libsigrokdecode
else
SIGROK_CLI_CONF_OPTS += --with-libsigrokdecode=NO
endif

$(eval $(autotools-package))
