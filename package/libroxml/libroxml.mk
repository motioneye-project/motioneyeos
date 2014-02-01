################################################################################
#
# libroxml
#
################################################################################

LIBROXML_VERSION = 2.3.0
LIBROXML_SITE = http://download.libroxml.net/pool/v2.x/
LIBROXML_INSTALL_STAGING = YES
LIBROXML_LICENSE = LGPLv2.1+ with static link exception
LIBROXML_LICENSE_FILES = License.txt

LIBROXML_CONF_OPT = --disable-silent-rules

$(eval $(autotools-package))
