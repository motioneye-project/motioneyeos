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

# Uses PKG_CHECK_MODULES() in configure.ac
EVEMU_DEPENDENCIES = host-pkgconf libevdev

# Needs Python to generate a wrapper
EVEMU_DEPENDENCIES += host-python

# package source code coming from git, so it doesn't have generated
# configure and Makefile.in
EVEMU_AUTORECONF = YES

$(eval $(autotools-package))
