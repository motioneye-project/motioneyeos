################################################################################
#
# tcl
#
################################################################################

TCL_VERSION_MAJOR = 8.4
TCL_VERSION_MINOR = 19
TCL_VERSION = $(TCL_VERSION_MAJOR).$(TCL_VERSION_MINOR)
TCL_SOURCE = tcl$(TCL_VERSION)-src.tar.gz
TCL_SITE = http://downloads.sourceforge.net/project/tcl/Tcl/$(TCL_VERSION_MAJOR).$(TCL_VERSION_MINOR)
TCL_LICENSE = tcl license
TCL_LICENSE_FILES = license.terms
TCL_SUBDIR = unix
TCL_CONF_OPT = \
		--disable-symbols \
		--disable-langinfo \
		--disable-framework

HOST_TCL_CONF_OPT = \
		--disable-symbols \
		--disable-langinfo \
		--disable-framework

ifeq ($(BR2_PACKAGE_TCL_DEL_ENCODINGS),y)
define TCL_REMOVE_ENCODINGS
	rm -rf $(TARGET_DIR)/usr/lib/tcl$(TCL_VERSION_MAJOR)/encoding/*
endef
TCL_POST_INSTALL_TARGET_HOOKS += TCL_REMOVE_ENCODINGS
endif

ifeq ($(BR2_PACKAGE_TCL_SHLIB_ONLY),y)
define TCL_REMOVE_TCLSH
	rm -f $(TARGET_DIR)/usr/bin/tclsh$(TCL_VERSION_MAJOR)
endef
TCL_POST_INSTALL_TARGET_HOOKS += TCL_REMOVE_TCLSH
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
