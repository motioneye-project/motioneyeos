################################################################################
#
# libedit
#
################################################################################

LIBEDIT_VERSION = 20150325-3.1
LIBEDIT_SITE = http://www.thrysoee.dk/editline
LIBEDIT_INSTALL_STAGING = YES
LIBEDIT_DEPENDENCIES = ncurses
LIBEDIT_LICENSE = BSD-3c
LIBEDIT_LICENSE_FILES = COPYING

# We're patching configure.ac
LIBEDIT_AUTORECONF = YES

# Needed for autoreconf to work properly
define LIBEDIT_FIXUP_M4_DIR
	mkdir $(@D)/m4
endef
LIBEDIT_POST_EXTRACT_HOOKS += LIBEDIT_FIXUP_M4_DIR

# Doesn't really support !wchar, but support is disabled otherwise
LIBEDIT_CONF_OPTS += --enable-widec

# musl is ISO 10646 compliant but doesn't define __STDC_ISO_10646__,
# so let's define it manually
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
LIBEDIT_CONF_OPTS += CFLAGS="$(TARGET_CFLAGS) -D__STDC_ISO_10646__=201103L"
endif

# Note: libbsd required for *vis functions, but works only with a toolchain
# with __progname; otherwise, some features are disabled, as if libbsd was
# missing entirely.
ifeq ($(BR2_PACKAGE_LIBBSD),y)
LIBEDIT_DEPENDENCIES += libbsd
endif

$(eval $(autotools-package))
