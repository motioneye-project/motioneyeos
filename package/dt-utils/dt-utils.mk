################################################################################
#
# dt-utils
#
################################################################################

DT_UTILS_VERSION = v2017.03.0
DT_UTILS_SITE = https://git.pengutronix.de/git/tools/dt-utils
DT_UTILS_SITE_METHOD = git
DT_UTILS_LICENSE = GPL-2.0
DT_UTILS_LICENSE_FILES = COPYING
DT_UTILS_DEPENDENCIES = udev
DT_UTILS_AUTORECONF = YES

$(eval $(autotools-package))
