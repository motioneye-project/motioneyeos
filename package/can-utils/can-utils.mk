################################################################################
#
# can-utils
#
################################################################################

CAN_UTILS_VERSION = 836d3cc0122ce31a1b732d369cbd27b690c3110f
CAN_UTILS_SITE = git://gitorious.org/linux-can/can-utils.git
CAN_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
