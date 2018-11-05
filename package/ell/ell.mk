################################################################################
#
# ell
#
################################################################################

ELL_VERSION = 0.13
ELL_SITE = https://git.kernel.org/pub/scm/libs/ell/ell.git
ELL_SITE_METHOD = git
ELL_LICENSE = LGPL-2.1+
ELL_LICENSE_FILES = COPYING
ELL_INSTALL_STAGING = YES
# sources from git, no configure script provided
ELL_AUTORECONF = YES

# autoreconf requires an existing build-aux directory
define ELL_MKDIR_BUILD_AUX
	mkdir -p $(@D)/build-aux
endef
ELL_POST_PATCH_HOOKS += ELL_MKDIR_BUILD_AUX

ELL_DEPENDENCIES = host-pkgconf

# disable ell/glib main loop example
ELL_CONF_OPTS = --disable-glib

$(eval $(autotools-package))
