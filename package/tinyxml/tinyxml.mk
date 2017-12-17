################################################################################
#
# tinyxml
#
################################################################################

TINYXML_VERSION = 2.6.2_2
TINYXML_SITE = http://mirrors.xbmc.org/build-deps/sources
# AUTORECONF is needed because the XBMC's version of TinyXML contains a
# configure.ac which is not present in mainline.
TINYXML_AUTORECONF = YES
TINYXML_INSTALL_STAGING = YES
TINYXML_LICENSE = Zlib
TINYXML_LICENSE_FILES = README

$(eval $(autotools-package))
