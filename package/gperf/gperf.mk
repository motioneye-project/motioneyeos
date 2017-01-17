################################################################################
#
# gperf
#
################################################################################

GPERF_VERSION = 3.0.4
GPERF_SITE = $(BR2_GNU_MIRROR)/gperf
GPERF_LICENSE = GPLv3+
GPERF_LICENSE_FILES = COPYING

$(eval $(autotools-package))
$(eval $(host-autotools-package))
