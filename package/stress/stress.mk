################################################################################
#
# stress
#
################################################################################

STRESS_VERSION = 1.0.4
STRESS_SITE = http://people.seas.harvard.edu/~apw/stress
STRESS_LICENSE = GPLv2+
STRESS_LICENSE_FILES = COPYING
STRESS_AUTORECONF = YES

# Stress is linked statically if the --enable-static is specified.
# However, this option is always specified in the global
# SHARED_STATIC_LIBS_OPTS to tell packages to build static libraries,
# if supported.
#
# If the BR2_PREFER_STATIC_LIB is not defined, we have to specify
# --disable-static explicitly to get stress linked dynamically.
#
# Also, disable documentation by undefining makeinfo
STRESS_CONF_OPT = \
	$(if $(BR2_PREFER_STATIC_LIB),,--disable-static) \
	MAKEINFO=:

$(eval $(autotools-package))
