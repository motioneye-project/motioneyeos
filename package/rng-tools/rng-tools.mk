################################################################################
#
# rng-tools
#
################################################################################

RNG_TOOLS_VERSION = 4
RNG_TOOLS_SITE = http://downloads.sourceforge.net/project/gkernel/rng-tools/$(RNG_TOOLS_VERSION)
RNG_TOOLS_CONF_ENV = LIBS="-largp"
RNG_TOOLS_DEPENDENCIES = argp-standalone
RNG_TOOLS_LICENSE = GPLv2
RNG_TOOLS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
