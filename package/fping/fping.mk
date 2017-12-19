################################################################################
#
# fping
#
################################################################################

FPING_VERSION = 4.0
FPING_SITE = http://fping.org/dist
FPING_LICENSE = BSD-like
FPING_LICENSE_FILES = COPYING

$(eval $(autotools-package))
