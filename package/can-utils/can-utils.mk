################################################################################
#
# can-utils
#
################################################################################

CAN_UTILS_VERSION = f0abaaacb0a3f620f73dd6fd716d7daa3c36a8e3
CAN_UTILS_SITE = $(call github,linux-can,can-utils,$(CAN_UTILS_VERSION))
CAN_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
