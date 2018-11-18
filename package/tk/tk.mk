################################################################################
#
# tk
#
################################################################################

TK_VERSION_MAJOR = 8.6
TK_VERSION = $(TK_VERSION_MAJOR).6
TK_SOURCE = tk$(TK_VERSION)-src.tar.gz
TK_SITE = http://downloads.sourceforge.net/project/tcl/Tcl/$(TK_VERSION)
TK_LICENSE = TCL
TK_LICENSE_FILES = license.terms
TK_SUBDIR = unix
TK_INSTALL_STAGING = YES

TK_DEPENDENCIES = tcl xlib_libX11 xlib_libXft

# hopefully our strtod is not buggy
TK_CONF_ENV = tcl_cv_strtod_buggy=no

TK_CONF_OPTS = --disable-rpath \
	--with-tcl=$(BUILD_DIR)/tcl-$(TCL_VERSION)/unix \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib

define TK_WISH_SYMLINK
	ln -sf /usr/bin/wish$(TK_VERSION_MAJOR) $(TARGET_DIR)/usr/bin/wish
endef
TK_POST_INSTALL_TARGET_HOOKS += TK_WISH_SYMLINK

$(eval $(autotools-package))
