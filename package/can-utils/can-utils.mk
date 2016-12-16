################################################################################
#
# can-utils
#
################################################################################

CAN_UTILS_VERSION = 64edc021d22441002028bc451548b9e7f1874b91
CAN_UTILS_SITE = $(call github,linux-can,can-utils,$(CAN_UTILS_VERSION))
CAN_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
