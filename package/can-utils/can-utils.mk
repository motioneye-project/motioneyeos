################################################################################
#
# can-utils
#
################################################################################

CAN_UTILS_VERSION = b70a76670dbe8925c2a7c75f90d36a28a8878d7a
CAN_UTILS_SITE = $(call github,linux-can,can-utils,$(CAN_UTILS_VERSION))
CAN_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
