################################################################################
#
# libedit
#
################################################################################

LIBEDIT_VERSION = 20130712-3.1
LIBEDIT_SITE = http://www.thrysoee.dk/editline
LIBEDIT_INSTALL_STAGING = YES
LIBEDIT_DEPENDENCIES = ncurses
LIBEDIT_LICENSE = BSD-3c
LIBEDIT_LICENSE_FILES = COPYING

# We're patching configure.ac
LIBEDIT_AUTORECONF = YES

# Doesn't really support !wchar, but support is disabled otherwise
LIBEDIT_CONF_OPT += --enable-widec

# Note: libbsd required for *vis functions, but works only with a toolchain
# with __progname; otherwise, some features are disabled, as if libbsd was
# missing entirely.
ifeq ($(BR2_PACKAGE_LIBBSD),y)
LIBEDIT_DEPENDENCIES += libbsd
endif

$(eval $(autotools-package))
