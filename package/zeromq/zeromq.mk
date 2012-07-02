#############################################################
#
# zeromq
#
#############################################################

ZEROMQ_VERSION = 2.1.11
ZEROMQ_SITE = http://download.zeromq.org/
ZEROMQ_INSTALL_STAGING = YES
ZEROMQ_DEPENDENCIES = util-linux

$(eval $(autotools-package))
