################################################################################
#
# can-utils
#
################################################################################

CAN_UTILS_VERSION = 002f8eba8703e88cdc6e97f6447a4ce346b739da
CAN_UTILS_SITE = $(call github,linux-can,can-utils,$(CAN_UTILS_VERSION))
CAN_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
