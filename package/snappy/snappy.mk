################################################################################
#
# snappy
#
################################################################################

SNAPPY_VERSION = be6dc3db83c4701e3e79694dcbfd1c3da03b91dd
SNAPPY_SITE = $(call github,google,snappy,$(SNAPPY_VERSION))
SNAPPY_LICENSE = BSD-3-Clause
SNAPPY_LICENSE_FILES = COPYING
SNAPPY_INSTALL_STAGING = YES
SNAPPY_CONF_OPTS = -DSNAPPY_BUILD_TESTS=OFF

$(eval $(cmake-package))
