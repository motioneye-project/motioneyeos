################################################################################
#
# evtest
#
################################################################################

EVTEST_VERSION = 1.34
EVTEST_SOURCE = evtest-evtest-$(EVTEST_VERSION).tar.gz
EVTEST_SITE = https://gitlab.freedesktop.org/libevdev/evtest/-/archive/evtest-$(EVTEST_VERSION)
EVTEST_LICENSE = GPL-2.0+
EVTEST_LICENSE_FILES = COPYING
EVTEST_DEPENDENCIES = host-pkgconf
# needed because source package contains no generated files
EVTEST_AUTORECONF = YES

# asciidoc used to generate manpages, which we don't need, and if it's
# present on the build host, it ends getting called with our host-python
# which doesn't have all the needed modules enabled, breaking the build
EVTEST_CONF_ENV = ac_cv_path_ASCIIDOC=""

$(eval $(autotools-package))
