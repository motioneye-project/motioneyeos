################################################################################
#
# iperf
#
################################################################################

IPERF_VERSION = 2.0.5
IPERF_SOURCE = iperf-$(IPERF_VERSION).tar.gz
IPERF_SITE = http://downloads.sourceforge.net/project/iperf

IPERF_CONF_ENV = \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_type_bool=yes \
	ac_cv_sizeof_bool=1

IPERF_CONF_OPT = \
	--disable-dependency-tracking \
	--disable-web100

$(eval $(autotools-package))
