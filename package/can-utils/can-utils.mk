################################################################################
#
# can-utils
#
################################################################################

CAN_UTILS_VERSION = 111f8d3acf6f6b30bf208fd9c98399c5fb9d29de
CAN_UTILS_SITE = git://gitorious.org/linux-can/can-utils.git
CAN_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
