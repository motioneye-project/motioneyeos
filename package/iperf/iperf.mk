#############################################################
#
# iperf
#
#############################################################

IPERF_VERSION:=2.0.2
IPERF_SOURCE:=iperf-$(IPERF_VERSION).tar.gz
IPERF_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/iperf
IPERF_AUTORECONF:=NO
IPERF_INSTALL_STAGING:=NO
IPERF_INSTALL_TARGET:=YES
IPERF_INSTALL_TARGET_OPT:=DESTDIR=$(TARGET_DIR) install-strip
IPERF_CONF_ENV:=ac_cv_func_malloc_0_nonnull=yes
IPERF_CONF_OPT:=--disable-dependency-tracking --disable-web100 $(DISABLE_IPV6)

IPERF_DEPENDENCIES:=uclibc

$(eval $(call AUTOTARGETS,package,iperf))
