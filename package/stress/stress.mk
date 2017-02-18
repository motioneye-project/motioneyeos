################################################################################
#
# stress
#
################################################################################

STRESS_VERSION = 1.0.4
STRESS_SITE = http://people.seas.harvard.edu/~apw/stress
STRESS_LICENSE = GPLv2+
STRESS_LICENSE_FILES = COPYING

# Stress is linked statically if the --enable-static is specified.
# However, this option is always specified in the global
# SHARED_STATIC_LIBS_OPTS to tell packages to build static libraries,
# if supported.
#
# If the BR2_STATIC_LIBS is not defined, we have to specify
# --disable-static explicitly to get stress linked dynamically.
#
# Also, disable documentation by undefining makeinfo
STRESS_CONF_OPTS = \
	$(if $(BR2_STATIC_LIBS),,--disable-static) \
	MAKEINFO=:

$(eval $(autotools-package))
