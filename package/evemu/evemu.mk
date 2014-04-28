################################################################################
#
# evemu
#
################################################################################

EVEMU_VERSION = 1.2.0
EVEMU_SITE = http://cgit.freedesktop.org/evemu/snapshot
EVEMU_LICENSE = LGPLv3 (library), GPLv3 (tools)
EVEMU_LICENSE_FILES = COPYING COPYING.GPL3

# asciidoc used to generate manpages, which we don't need, and if it's
# present on the build host, it ends getting called with our host-python
# which doesn't have all the needed modules enabled, breaking the build
EVEMU_CONF_ENV = ac_cv_path_ASCIIDOC=""

# needed for make-event-names.py to find sysroot provided input.h (instead
# of host system version)
EVEMU_MAKE_ENV = SYSROOT=$(STAGING_DIR)

# disable tests generation because of C++ dependency
EVEMU_CONF_OPT += --disable-tests

# Uses PKG_CHECK_MODULES() in configure.ac
EVEMU_DEPENDENCIES = host-pkgconf libevdev

# Needs Python for header file generation
EVEMU_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON3),host-python3,host-python)

# Check for target python
ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
EVEMU_CONF_OPT += --enable-python-bindings
EVEMU_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON3),python3,python)
else
EVEMU_CONF_OPT += --disable-python-bindings
endif

# package source code coming from git, so it doesn't have generated
# configure and Makefile.in
EVEMU_AUTORECONF = YES

$(eval $(autotools-package))
