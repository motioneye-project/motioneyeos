################################################################################
#
# gli
#
################################################################################

GLI_VERSION = 559cbe1ec38878e182507d331e0780fbae5baf15
GLI_SITE = $(call github,g-truc,gli,$(GLI_VERSION))
GLI_LICENSE = MIT
GLI_LICENSE_FILES = manual.md

# GLI is a header-only library, it only makes sense
# to have it installed into the staging directory.
GLI_INSTALL_STAGING = YES
GLI_INSTALL_TARGET = NO

$(eval $(cmake-package))
