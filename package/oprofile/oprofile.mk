#############################################################
#
# oprofile
#
#############################################################
OPROFILE_VERSION := 0.9.4
OPROFILE_CONF_OPT := --localstatedir=/var \
		     --with-extra-includes="$(BUILD_DIR)/binutils-$(BR2_BINUTILS_VERSION)-target/bfd -I$(TOOL_BUILD_DIR)/binutils-$(BR2_BINUTILS_VERSION)/include" \
		     --with-extra-libs=$(BUILD_DIR)/binutils-$(BR2_BINUTILS_VERSION)-target/bfd \
		     --with-kernel-support

OPROFILE_BINARIES := utils/ophelp
OPROFILE_BINARIES += pp/opannotate pp/oparchive pp/opgprof pp/opreport opjitconv/opjitconv
OPROFILE_BINARIES += daemon/oprofiled

ifeq ($(BR2_powerpc),y)
OPROFILE_ARCH := ppc
endif
ifeq ($(BR2_x86_64),y)
OPROFILE_ARCH := x86-64
endif
ifeq ($(OPROFILE_ARCH),)
OPROFILE_ARCH := $(BR2_ARCH)
endif

OPROFILE_DEPENDENCIES := popt binutils_target

$(eval $(call AUTOTARGETS,package,oprofile))

$(OPROFILE_TARGET_INSTALL_TARGET):
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/bin
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/share/oprofile
	cp -dpfr $(OPROFILE_DIR)/events/$(OPROFILE_ARCH) $(TARGET_DIR)/usr/share/oprofile
	$(INSTALL) -m 644 $(OPROFILE_DIR)/libregex/stl.pat $(TARGET_DIR)/usr/share/oprofile
	$(INSTALL) -m 755 $(OPROFILE_DIR)/utils/opcontrol $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 755 $(addprefix $(OPROFILE_DIR)/, $(OPROFILE_BINARIES)) $(TARGET_DIR)/usr/bin
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(addprefix $(TARGET_DIR)/usr/bin/, $(notdir $(OPROFILE_BINARIES)))
	touch $@

$(OPROFILE_TARGET_CLEAN):
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(notdir $(OPROFILE_BINARIES)))
	rm -f $(TARGET_DIR)/usr/bin/opcontrol
	rm -rf $(TARGET_DIR)/usr/share/oprofile
	-$(MAKE) -C $(OPROFILE_DIR) clean
	touch $@
