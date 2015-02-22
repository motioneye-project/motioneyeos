################################################################################
#
# evtest
#
################################################################################

EVTEST_VERSION = 1.32
EVTEST_SOURCE = evtest-$(EVTEST_VERSION).tar.gz
EVTEST_SITE = http://cgit.freedesktop.org/evtest/snapshot
EVTEST_LICENSE = GPLv2+
EVTEST_LICENSE_FILES = COPYING
EVTEST_DEPENDENCIES = host-pkgconf
# needed because source package contains no generated files
EVTEST_AUTORECONF = YES

# asciidoc used to generate manpages, which we don't need, and if it's
# present on the build host, it ends getting called with our host-python
# which doesn't have all the needed modules enabled, breaking the build
EVTEST_CONF_ENV = ac_cv_path_ASCIIDOC=""

$(eval $(autotools-package))
