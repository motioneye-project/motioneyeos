################################################################################
#
# iperf
#
################################################################################

IPERF_VERSION = 2.0.10
IPERF_SITE = http://downloads.sourceforge.net/project/iperf2
IPERF_LICENSE = MIT-like
IPERF_LICENSE_FILES = COPYING
# patching configure.ac
IPERF_AUTORECONF = YES

IPERF_CONF_OPTS = \
	--disable-web100

$(eval $(autotools-package))
