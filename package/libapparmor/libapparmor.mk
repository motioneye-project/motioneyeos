################################################################################
#
# libapparmor
#
################################################################################

# When updating the version here, please also update the apparmor package
LIBAPPARMOR_VERSION_MAJOR = 2.13
LIBAPPARMOR_VERSION = $(LIBAPPARMOR_VERSION_MAJOR).4
LIBAPPARMOR_SOURCE = apparmor-$(LIBAPPARMOR_VERSION).tar.gz
LIBAPPARMOR_SITE = https://launchpad.net/apparmor/$(LIBAPPARMOR_VERSION_MAJOR)/$(LIBAPPARMOR_VERSION)/+download
LIBAPPARMOR_LICENSE = LGPL-2.1
LIBAPPARMOR_LICENSE_FILES = LICENSE libraries/libapparmor/COPYING.LGPL

LIBAPPARMOR_DEPENDENCIES = host-bison host-flex host-pkgconf
LIBAPPARMOR_SUBDIR = libraries/libapparmor
LIBAPPARMOR_INSTALL_STAGING = YES

# Patches 0001 and 0002 touch Makefile.am and an m4 file
LIBAPPARMOR_AUTORECONF = YES

# Most AppArmor tools will want to link to the static lib.
# ac_cv_prog_cc_c99 is required for BR2_USE_WCHAR=n because the C99 test
# provided by autoconf relies on wchar_t.
LIBAPPARMOR_CONF_OPTS = \
	ac_cv_prog_cc_c99=-std=gnu99 \
	--enable-static \
	--disable-man-pages

ifeq ($(BR2_PACKAGE_PYTHON3),y)
LIBAPPARMOR_DEPENDENCIES += host-python3 host-swig python3
LIBAPPARMOR_CONF_OPTS += \
	--with-python \
	PYTHON=$(HOST_DIR)/usr/bin/python3 \
	PYTHON_CONFIG=$(STAGING_DIR)/usr/bin/python3-config \
	SWIG=$(SWIG)
else
LIBAPPARMOR_CONF_OPTS += --without-python
endif

define LIBAPPARMOR_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_AUDIT)
	$(call KCONFIG_ENABLE_OPT,CONFIG_SECURITY)
	$(call KCONFIG_ENABLE_OPT,CONFIG_SECURITY_APPARMOR)
	$(call KCONFIG_ENABLE_OPT,CONFIG_DEFAULT_SECURITY_APPARMOR)
endef

$(eval $(autotools-package))
