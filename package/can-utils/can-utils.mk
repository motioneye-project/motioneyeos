################################################################################
#
# can-utils
#
################################################################################

CAN_UTILS_VERSION = 0eb1e3db2e20b0d895468363dbe6030cd8afa61c
CAN_UTILS_SITE = $(call github,linux-can,can-utils,$(CAN_UTILS_VERSION))
CAN_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
