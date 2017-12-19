################################################################################
#
# atf
#
################################################################################

ATF_VERSION = 0.21
ATF_SITE = https://github.com/jmmv/atf/releases/download/atf-$(ATF_VERSION)
ATF_INSTALL_STAGING = YES
ATF_LICENSE = BSD-2-Clause, BSD-3-Clause
ATF_LICENSE_FILES = COPYING
# Ships a beta libtool version hence our patch doesn't apply.
ATF_AUTORECONF = YES
# Do not install precompiled tests.
ATF_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) install-exec

# ATF_SHELL defaults to the host's bash
ATF_CONF_ENV = \
	kyua_cv_getopt_plus=yes \
	kyua_cv_attribute_noreturn=yes \
	kyua_cv_getcwd_works=yes \
	ATF_SHELL=/bin/sh

$(eval $(autotools-package))
