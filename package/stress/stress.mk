#############################################################
#
# stress - a workload generator
#
# http://weather.ou.edu/~apw/projects/stress/
#
#############################################################

STRESS_VERSION = 1.0.4
STRESS_SITE    = http://weather.ou.edu/~apw/projects/stress
STRESS_AUTORECONF = YES

$(eval $(autotools-package))
