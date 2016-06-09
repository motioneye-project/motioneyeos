################################################################################
#
# iperf3
#
################################################################################

IPERF3_VERSION = 3.1.3
IPERF3_SITE = http://downloads.es.net/pub/iperf
IPERF3_SOURCE = iperf-$(IPERF3_VERSION).tar.gz
IPERF3_LICENSE = BSD-3c, BSD-2c, MIT
IPERF3_LICENSE_FILES = LICENSE

IPERF3_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

$(eval $(autotools-package))
