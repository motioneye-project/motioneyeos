#############################################################
#
# iperf
#
#############################################################
IPERF_VERSION = 2.0.5
IPERF_SOURCE = iperf-$(IPERF_VERSION).tar.gz
IPERF_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/iperf

IPERF_AUTORECONF = NO

IPERF_INSTALL_STAGING = NO
IPERF_INSTALL_TARGET = YES

IPERF_CONF_ENV = \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_type_bool=yes \
	ac_cv_sizeof_bool=1

IPERF_CONF_OPT = \
	--disable-dependency-tracking \
	--disable-web100

$(eval $(call AUTOTARGETS,package,iperf))
