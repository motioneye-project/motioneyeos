#############################################################
#
# TCL8.4
#
#############################################################
TCL_VERSION:=8.4.19
TCL_SOURCE:=tcl$(TCL_VERSION)-src.tar.gz
TCL_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/tcl
TCL_SUBDIR = unix
TCL_CONF_OPT = \
		--enable-shared \
		--disable-symbols \
		--disable-langinfo \
		--disable-framework

define TCL_POST_INSTALL_CLEANUP
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libtcl8.4.so
	-if [ "$(BR2_PACKAGE_TCL_DEL_ENCODINGS)" = "y" ]; then \
	rm -Rf $(TARGET_DIR)/usr/lib/tcl8.4/encoding/*; \
	fi
	-if [ "$(BR2_PACKAGE_TCL_SHLIB_ONLY)" = "y" ]; then \
	rm -f $(TARGET_DIR)/usr/bin/tclsh8.4; \
	fi
endef

TCL_POST_INSTALL_TARGET_HOOKS += TCL_POST_INSTALL_CLEANUP

$(eval $(call AUTOTARGETS,package,tcl))
