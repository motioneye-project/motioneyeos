#############################################################
#
# gperf
#
#############################################################

GPERF_VERSION = 3.0.4
GPERF_SITE = $(BR2_GNU_MIRROR)/gperf

$(eval $(call AUTOTARGETS,package,gperf))
$(eval $(call AUTOTARGETS,package,gperf,host))
