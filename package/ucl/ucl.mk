################################################################################
#
# ucl
#
################################################################################

UCL_VERSION = 1.03
UCL_SITE = http://www.oberhumer.com/opensource/ucl/download
UCL_LICENSE = GPLv2+
UCL_LICENSE_FILES = COPYING

$(eval $(host-autotools-package))
