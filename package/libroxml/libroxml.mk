################################################################################
#
# libroxml
#
################################################################################

LIBROXML_VERSION = 2.3.0
LIBROXML_SITE = http://download.libroxml.net/pool/v2.x
LIBROXML_INSTALL_STAGING = YES
LIBROXML_LICENSE = LGPLv2.1+ with static link exception
LIBROXML_LICENSE_FILES = License.txt

LIBROXML_CONF_OPTS = --disable-silent-rules

# libroxml forgets to compile/link with -pthread, even though it uses
# thread functions breaking static linking
LIBROXML_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -pthread" LIBS="-pthread"

$(eval $(autotools-package))
