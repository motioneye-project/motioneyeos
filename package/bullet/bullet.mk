################################################################################
#
# bullet
#
################################################################################

# This is the git id of the 2.82 release.
BULLET_VERSION = 19f999ac087e68ffc2551ffb73e35e60271a0d27
BULLET_SITE = $(call github,bulletphysics,bullet3,$(BULLET_VERSION))
BULLET_INSTALL_STAGING = YES
BULLET_LICENSE = zlib license
BULLET_LICENSE_FILES = BulletLicense.txt COPYING

# Disable GLUT support since there is no freeglut or OpenGLUT package and we
# don't build the demos apps.
BULLET_CONF_OPTS = -DUSE_GLUT=OFF -DBUILD_DEMOS=OFF

$(eval $(cmake-package))
