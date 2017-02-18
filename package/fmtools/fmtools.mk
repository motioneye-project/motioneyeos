################################################################################
#
# fmtools
#
################################################################################

FMTOOLS_VERSION = 2.0.7
FMTOOLS_SITE = http://benpfaff.org/fmtools
FMTOOLS_LICENSE = GPLv2+
FMTOOLS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
