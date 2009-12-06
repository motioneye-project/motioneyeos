#############################################################
#
# iperf
#
#############################################################

IPERF_VERSION:=2.0.3
IPERF_SOURCE:=iperf-$(IPERF_VERSION).tar.gz
IPERF_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/iperf
IPERF_AUTORECONF:=NO
IPERF_CONF_OPT:=--disable-dependency-tracking --disable-web100

$(eval $(call AUTOTARGETS,package,iperf))
