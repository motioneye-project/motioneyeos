#############################################################
#
# TCL8.4
#
#############################################################
TCL_VERSION:=8.4.9
TCL_SOURCE:=tcl$(TCL_VERSION)-src.tar.gz
TCL_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/tcl
TCL_DIR:=$(BUILD_DIR)/tcl$(TCL_VERSION)

$(DL_DIR)/$(TCL_SOURCE):
	$(WGET) -P $(DL_DIR) $(TCL_SITE)/$(TCL_SOURCE)

$(TCL_DIR)/.source: $(DL_DIR)/$(TCL_SOURCE)
	$(ZCAT) $(DL_DIR)/$(TCL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(TCL_DIR) package/tcl/ tcl\*.patch
	touch $(TCL_DIR)/.source

$(TCL_DIR)/.configured: $(TCL_DIR)/.source
	(cd $(TCL_DIR)/unix; rm -f config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--enable-shared \
		--disable-symbols \
		--disable-langinfo \
		--disable-framework \
	)
	touch $(TCL_DIR)/.configured

$(TCL_DIR)/unix/libtcl8.4.so: $(TCL_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(TCL_DIR)/unix

$(TARGET_DIR)/usr/lib/libtcl8.4.so: $(TCL_DIR)/unix/libtcl8.4.so
	$(MAKE) INSTALL_ROOT=$(TARGET_DIR) -C $(TCL_DIR)/unix install
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libtcl8.4.so
	rm -Rf $(TARGET_DIR)/usr/man
	-if [ "$(BR2_PACKAGE_TCL_DEL_ENCODINGS)" == "y" ]; then \
	rm -Rf $(TARGET_DIR)/usr/lib/tcl8.4/encoding/*; \
	fi
	-if [ "$(BR2_PACKAGE_TCL_SHLIB_ONLY)" == "y" ]; then \
	rm -f $(TARGET_DIR)/usr/bin/tclsh8.4; \
	fi

tcl: uclibc $(TARGET_DIR)/usr/lib/libtcl8.4.so

tcl-source: $(DL_DIR)/$(TCL_SOURCE)

tcl-clean:
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(TCL_DIR)/unix uninstall
	-$(MAKE) -C $(TCL_DIR)/unix clean

tcl-dirclean:
	rm -rf $(TCL_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_TCL),y)
TARGETS+=tcl
endif
