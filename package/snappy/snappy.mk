################################################################################
#
# snappy
#
################################################################################

SNAPPY_VERSION = 1ff9be9b8fafc8528ca9e055646f5932aa5db9c4
SNAPPY_SITE = $(call github,google,snappy,$(SNAPPY_VERSION))
SNAPPY_LICENSE = BSD-3c
SNAPPY_LICENSE_FILES = COPYING
# from git
SNAPPY_AUTORECONF = YES
SNAPPY_DEPENDENCIES = host-pkgconf
SNAPPY_INSTALL_STAGING = YES

# Disable tests
SNAPPY_CONF_OPTS = --disable-gtest

$(eval $(autotools-package))
