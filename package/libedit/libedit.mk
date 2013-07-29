################################################################################
#
# libedit
#
################################################################################

LIBEDIT_VERSION         = 20130712-3.1
LIBEDIT_SITE            = http://www.thrysoee.dk/editline/
LIBEDIT_INSTALL_STAGING = YES
LIBEDIT_DEPENDENCIES    = ncurses

# We're patching configure.ac
LIBEDIT_AUTORECONF      = YES

# Note: libbsd required for *vis functions, but works only with a toolchain
# with __progname; otherwise, some features are disabled, as if libbsd was
# missing entirely.
ifeq ($(BR2_PACKAGE_LIBBSD),y)
LIBEDIT_DEPENDENCIES   += libbsd
endif

# Wide-char support is not autodetected by configure, we have to help a bit.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_WCHAR),y)
LIBEDIT_CONF_OPT       += --enable-widec
else
LIBEDIT_CONF_OPT       += --disable-widec
endif

$(eval $(autotools-package))
