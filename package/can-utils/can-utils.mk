################################################################################
#
# can-utils
#
################################################################################

CAN_UTILS_VERSION = c3305fdd515464153d20199db232b6124bc962c0
CAN_UTILS_SITE = $(call github,linux-can,can-utils,$(CAN_UTILS_VERSION))
CAN_UTILS_LICENSE = BSD-3-Clause or GPL-2.0, GPL-2.0+
CAN_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
