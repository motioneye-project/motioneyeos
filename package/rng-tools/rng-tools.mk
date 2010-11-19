#############################################################
#
# rng-tools
#
#############################################################

RNG_TOOLS_VERSION = 3
RNG_TOOLS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/gkernel
RNG_TOOLS_CONF_ENV = LIBS="-largp"
RNG_TOOLS_DEPENDENCIES = argp-standalone

$(eval $(call AUTOTARGETS,package,rng-tools))
