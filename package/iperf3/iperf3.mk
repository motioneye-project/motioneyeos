################################################################################
#
# iperf3
#
################################################################################

IPERF3_VERSION = 3.0.10
IPERF3_SITE = $(call github,esnet,iperf,$(IPERF3_VERSION))
IPERF3_LICENSE = BSD-3c, BSD-2c, MIT
IPERF3_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
