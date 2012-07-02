#############################################################
#
# can-utils
#
#############################################################

CAN_UTILS_VERSION = 50775159276d896d8b3102b6dbc658a91a2a1d53
CAN_UTILS_SITE = git://gitorious.org/linux-can/can-utils.git
CAN_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
