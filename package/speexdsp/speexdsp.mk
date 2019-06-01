################################################################################
#
# speexdsp
#
################################################################################

SPEEXDSP_VERSION = SpeexDSP-1.2.0
SPEEXDSP_SITE = https://git.xiph.org/speexdsp.git
SPEEXDSP_SITE_METHOD = git
SPEEXDSP_LICENSE = BSD-3-Clause
SPEEXDSP_LICENSE_FILES = COPYING
SPEEXDSP_INSTALL_STAGING = YES
SPEEXDSP_DEPENDENCIES = host-pkgconf
SPEEXDSP_AUTORECONF = YES

# Autoreconf step fails due to missing m4 directory
define SPEEXDSP_CREATE_M4_DIR
	mkdir -p $(@D)/m4
endef
SPEEXDSP_PRE_CONFIGURE_HOOKS += SPEEXDSP_CREATE_M4_DIR

$(eval $(autotools-package))
