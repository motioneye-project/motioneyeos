#############################################################
#
# rng-tools
#
#############################################################

RNG_TOOLS_VERSION = 3
RNG_TOOLS_SITE = http://downloads.sourceforge.net/project/gkernel/rng-tools/$(RNG_TOOLS_VERSION)
RNG_TOOLS_CONF_ENV = LIBS="-largp"
RNG_TOOLS_DEPENDENCIES = argp-standalone

$(eval $(autotools-package))
