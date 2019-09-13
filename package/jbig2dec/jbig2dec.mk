################################################################################
#
# jbig2dec
#
################################################################################

JBIG2DEC_VERSION = 0.16
JBIG2DEC_SITE = https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs927
JBIG2DEC_LICENSE = AGPL-3.0+
JBIG2DEC_LICENSE_FILES = LICENSE
JBIG2DEC_INSTALL_STAGING = YES

$(eval $(autotools-package))
