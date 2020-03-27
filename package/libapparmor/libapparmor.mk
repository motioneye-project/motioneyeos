################################################################################
#
# libapparmor
#
################################################################################

LIBAPPARMOR_VERSION_MAJOR = 2.13
LIBAPPARMOR_VERSION = $(LIBAPPARMOR_VERSION_MAJOR).3
LIBAPPARMOR_SOURCE = apparmor-$(LIBAPPARMOR_VERSION).tar.gz
LIBAPPARMOR_SITE = https://launchpad.net/apparmor/$(LIBAPPARMOR_VERSION_MAJOR)/$(LIBAPPARMOR_VERSION)/+download
LIBAPPARMOR_LICENSE = LGPL-2.1
LIBAPPARMOR_LICENSE_FILES = LICENSE libraries/libapparmor/COPYING.LGPL

LIBAPPARMOR_DEPENDENCIES = host-bison host-flex host-pkgconf
LIBAPPARMOR_SUBDIR = libraries/libapparmor
LIBAPPARMOR_INSTALL_STAGING = YES

# Most AppArmor tools will want to link to the static lib.
# ac_cv_prog_cc_c99 is required for BR2_USE_WCHAR=n because the C99 test
# provided by autoconf relies on wchar_t.
LIBAPPARMOR_CONF_OPTS = \
	ac_cv_prog_cc_c99=-std=gnu99 \
	--enable-static \
	--disable-man-pages \
	--without-python

$(eval $(autotools-package))
