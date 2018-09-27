################################################################################
#
# bird
#
################################################################################

BIRD_VERSION = v2.0.2
BIRD_SITE = $(call github,BIRD,bird,$(BIRD_VERSION))
BIRD_LICENSE = GPL-2.0+
BIRD_LICENSE_FILES = README
# autoreconf is needed since the package is fetched from github
BIRD_AUTORECONF = YES
BIRD_DEPENDENCIES = host-flex host-bison

ifeq ($(BR2_PACKAGE_BIRD_CLIENT),y)
BIRD_CONF_OPTS += --enable-client
BIRD_DEPENDENCIES += ncurses readline
else
BIRD_CONF_OPTS += --disable-client
endif

$(eval $(autotools-package))
