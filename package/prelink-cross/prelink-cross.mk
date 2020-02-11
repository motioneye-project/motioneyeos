################################################################################
#
# host-prelink-cross
#
################################################################################

PRELINK_CROSS_VERSION = a853a5d715d84eec93aa68e8f2df26b7d860f5b2
PRELINK_CROSS_SITE = https://git.yoctoproject.org/git/prelink-cross
PRELINK_CROSS_SITE_METHOD = git
PRELINK_CROSS_LICENSE = GPL-2.0+
PRELINK_CROSS_LICENSE_FILES = COPYING
# Sources from git, no configure script present
PRELINK_CROSS_AUTORECONF = YES
HOST_PRELINK_CROSS_DEPENDENCIES = host-elfutils host-libiberty

$(eval $(host-autotools-package))
