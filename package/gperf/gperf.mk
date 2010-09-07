#############################################################
#
# gperf
#
#############################################################
GPERF_VERSION = 3.0.3
GPERF_SOURCE = gperf-$(GPERF_VERSION).tar.gz
GPERF_SITE = $(BR2_GNU_MIRROR)/gperf
GPERF_AUTORECONF = NO
GPERF_INSTALL_STAGING = NO
GPERF_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS,package,gperf))
$(eval $(call AUTOTARGETS,package,gperf,host))
