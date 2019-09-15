################################################################################
#
# fping
#
################################################################################

FPING_VERSION = 4.2
FPING_SITE = http://fping.org/dist
FPING_LICENSE = BSD-like
FPING_LICENSE_FILES = COPYING

$(eval $(autotools-package))
