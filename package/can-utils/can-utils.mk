################################################################################
#
# can-utils
#
################################################################################

CAN_UTILS_VERSION = 16c970d40e6c19dde705bad4751bab1a3a4f3a0d
CAN_UTILS_SITE = git://gitorious.org/linux-can/can-utils.git
CAN_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
