################################################################################
#
# iperf3
#
################################################################################

IPERF3_VERSION = 3.1.1
IPERF3_SITE = $(call github,esnet,iperf,$(IPERF3_VERSION))
IPERF3_LICENSE = BSD-3c, BSD-2c, MIT
IPERF3_LICENSE_FILES = LICENSE

IPERF3_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

$(eval $(autotools-package))
