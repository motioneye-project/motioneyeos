################################################################################
#
# libupnp
#
################################################################################

LIBUPNP_VERSION = 1.6.24
LIBUPNP_SOURCE = libupnp-$(LIBUPNP_VERSION).tar.bz2
LIBUPNP_SITE = http://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%20$(LIBUPNP_VERSION)
LIBUPNP_CONF_ENV = ac_cv_lib_compat_ftime=no
LIBUPNP_INSTALL_STAGING = YES
LIBUPNP_LICENSE = BSD-3-Clause
LIBUPNP_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
