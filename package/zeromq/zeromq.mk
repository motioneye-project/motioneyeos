#############################################################
#
# zeromq
#
#############################################################

ZEROMQ_VERSION = 2.2.0
ZEROMQ_SITE = http://download.zeromq.org/
ZEROMQ_INSTALL_STAGING = YES
ZEROMQ_DEPENDENCIES = util-linux
ZEROMQ_LICENSE = LGPLv3+ with exceptions
ZEROMQ_LICENSE_FILES = COPYING COPYING.LESSER

$(eval $(autotools-package))
