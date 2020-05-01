################################################################################
#
# jbig2dec
#
################################################################################

JBIG2DEC_VERSION = 0.18
JBIG2DEC_SITE = https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs952
JBIG2DEC_LICENSE = AGPL-3.0+
JBIG2DEC_LICENSE_FILES = LICENSE
JBIG2DEC_INSTALL_STAGING = YES
# tarball is missing install-sh, install.sh, or shtool
JBIG2DEC_AUTORECONF = YES

$(eval $(autotools-package))
