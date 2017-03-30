################################################################################
#
# evemu
#
################################################################################

EVEMU_VERSION = 2.5.0
EVEMU_SITE = http://www.freedesktop.org/software/evemu
EVEMU_SOURCE = evemu-$(EVEMU_VERSION).tar.xz
EVEMU_LICENSE = LGPL-3.0 (library), GPL-3.0 (tools)
EVEMU_LICENSE_FILES = COPYING

# asciidoc used to generate manpages, which we don't need, and if it's
# present on the build host, it ends getting called with our host-python
# which doesn't have all the needed modules enabled, breaking the build
EVEMU_CONF_ENV = ac_cv_path_ASCIIDOC=""

# disable tests generation because of C++ dependency
EVEMU_CONF_OPTS += --disable-tests

# Uses PKG_CHECK_MODULES() in configure.ac
EVEMU_DEPENDENCIES = host-pkgconf libevdev

# Check for target python
ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
EVEMU_CONF_OPTS += --enable-python-bindings
EVEMU_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON3),python3,python)
else
EVEMU_CONF_OPTS += --disable-python-bindings
endif

$(eval $(autotools-package))
