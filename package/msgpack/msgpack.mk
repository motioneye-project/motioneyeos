################################################################################
#
# msgpack
#
################################################################################

MSGPACK_VERSION = 0.5.4
MSGPACK_SITE = http://downloads.sourceforge.net/project/msgpack/msgpack/cpp/
MSGPACK_LICENSE = Apache-2.0
MSGPACK_LICENSE_FILES = COPYING

$(eval $(autotools-package))
