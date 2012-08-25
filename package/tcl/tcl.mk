#############################################################
#
# TCL8.4
#
#############################################################
TCL_VERSION_MAJOR = 8.4
TCL_VERSION_MINOR = 19
TCL_VERSION = $(TCL_VERSION_MAJOR).$(TCL_VERSION_MINOR)
TCL_SOURCE = tcl$(TCL_VERSION)-src.tar.gz
TCL_SITE = http://downloads.sourceforge.net/project/tcl/Tcl/$(TCL_VERSION_MAJOR).$(TCL_VERSION_MINOR)
TCL_SUBDIR = unix
TCL_CONF_OPT = \
		--disable-symbols \
		--disable-langinfo \
		--disable-framework

HOST_TCL_CONF_OPT = \
		--disable-symbols \
		--disable-langinfo \
		--disable-framework

define TCL_POST_INSTALL_CLEANUP
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libtcl8.4.so
	-if [ "$(BR2_PACKAGE_TCL_DEL_ENCODINGS)" = "y" ]; then \
	rm -Rf $(TARGET_DIR)/usr/lib/tcl$(TCL_VERSION_MAJOR)/encoding/*; \
	fi
	-if [ "$(BR2_PACKAGE_TCL_SHLIB_ONLY)" = "y" ]; then \
	rm -f $(TARGET_DIR)/usr/bin/tclsh$(TCL_VERSION_MAJOR); \
	fi
endef

TCL_POST_INSTALL_TARGET_HOOKS += TCL_POST_INSTALL_CLEANUP

$(eval $(autotools-package))
$(eval $(host-autotools-package))
