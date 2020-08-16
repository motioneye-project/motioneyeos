################################################################################
#
# speexdsp
#
################################################################################

SPEEXDSP_VERSION = SpeexDSP-1.2.0
SPEEXDSP_SITE = https://gitlab.xiph.org/xiph/speexdsp.git
SPEEXDSP_SITE_METHOD = git
SPEEXDSP_LICENSE = BSD-3-Clause
SPEEXDSP_LICENSE_FILES = COPYING
SPEEXDSP_INSTALL_STAGING = YES
SPEEXDSP_DEPENDENCIES = host-pkgconf
SPEEXDSP_AUTORECONF = YES

$(eval $(autotools-package))
