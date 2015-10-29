################################################################################
#
# iperf3
#
################################################################################

IPERF3_VERSION = 3.1
IPERF3_SITE = https://iperf.fr/download/iperf_$(IPERF3_VERSION)
IPERF3_SOURCE = iperf-$(IPERF3_VERSION)-source.tar.gz
IPERF3_LICENSE = BSD-3c, BSD-2c, MIT
IPERF3_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
