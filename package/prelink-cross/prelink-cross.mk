################################################################################
#
# host-prelink-cross
#
################################################################################

HOST_PRELINK_CROSS_VERSION = a853a5d715d84eec93aa68e8f2df26b7d860f5b2
HOST_PRELINK_CROSS_SITE = git://git.yoctoproject.org/prelink-cross
HOST_PRELINK_CROSS_SITE_METHOD = git
HOST_PRELINK_CROSS_LICENSE = GPL-2.0
HOST_PRELINK_CROSS_LICENSE_FILES = COPYING
HOST_PRELINK_CROSS_AUTORECONF = YES
HOST_PRELINK_CROSS_DEPENDENCIES = host-binutils host-elfutils

$(eval $(host-autotools-package))
