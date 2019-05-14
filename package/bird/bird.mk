################################################################################
#
# bird
#
################################################################################

BIRD_VERSION = 2.0.3
BIRD_SITE = ftp://bird.network.cz/pub/bird
BIRD_LICENSE = GPL-2.0+
BIRD_LICENSE_FILES = README
BIRD_DEPENDENCIES = host-flex host-bison

ifeq ($(BR2_PACKAGE_BIRD_CLIENT),y)
BIRD_CONF_OPTS += --enable-client
BIRD_DEPENDENCIES += ncurses readline
else
BIRD_CONF_OPTS += --disable-client
endif

$(eval $(autotools-package))
