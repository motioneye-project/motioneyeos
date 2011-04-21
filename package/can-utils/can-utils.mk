#############################################################
#
# can-utils
#
#############################################################

CAN_UTILS_VERSION = 1235
CAN_UTILS_SITE = svn://svn.berlios.de/socketcan/trunk/can-utils
CAN_UTILS_AUTORECONF = YES

$(eval $(call AUTOTARGETS,package,can-utils))
