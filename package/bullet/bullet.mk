################################################################################
#
# bullet
#
################################################################################

BULLET_VERSION = 2.85.1
BULLET_SITE = $(call github,bulletphysics,bullet3,$(BULLET_VERSION))
BULLET_INSTALL_STAGING = YES
BULLET_LICENSE = zlib license
BULLET_LICENSE_FILES = LICENSE.txt

# Disable demos apps and unit tests.
# Disable Bullet3 library.
BULLET_CONF_OPTS = -DBUILD_UNIT_TESTS=OFF \
	-DBUILD_BULLET2_DEMOS=OFF \
	-DBUILD_BULLET3=OFF

$(eval $(cmake-package))
