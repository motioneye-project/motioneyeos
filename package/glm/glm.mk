################################################################################
#
# glm
#
################################################################################

GLM_VERSION = 0.9.5.4
GLM_SITE = $(call github,g-truc,glm,$(GLM_VERSION))
GLM_LICENSE = MIT
GLM_LICENSE_FILES = copying.txt

# GLM is a header-only library, it only makes sense
# to have it installed into the staging directory.
GLM_INSTALL_STAGING = YES
GLM_INSTALL_TARGET = NO

$(eval $(cmake-package))
