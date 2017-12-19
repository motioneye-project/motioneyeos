################################################################################
#
# on2-8170-modules
#
################################################################################

ON2_8170_MODULES_VERSION = 73b08061d30789178e692bc332b73d1d9922bf39
ON2_8170_MODULES_SITE = $(call github,alexandrebelloni,on2-8170-modules,$(ON2_8170_MODULES_VERSION))

ON2_8170_MODULES_LICENSE = GPL-2.0+
#There is no license file

$(eval $(kernel-module))
$(eval $(generic-package))
