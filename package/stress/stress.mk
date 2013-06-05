################################################################################
#
# stress
#
################################################################################

STRESS_VERSION = 1.0.4
STRESS_SITE    = http://weather.ou.edu/~apw/projects/stress
STRESS_AUTORECONF = YES

# Stress is linked statically if the --enable-static is specified.
# However, this option is always specified in the global
# SHARED_STATIC_LIBS_OPTS to tell packages to build static libraries,
# if supported.
#
# If the BR2_PREFER_STATIC_LIB is not defined, we have to specify
# --disable-static explicitly to get stress linked dynamically.
STRESS_CONF_OPT = \
	$(if $(BR2_PREFER_STATIC_LIB),,--disable-static)

$(eval $(autotools-package))
