#############################################################
#
# oprofile
#
#############################################################
OPROFILE_VERSION	:= 0.9.3
OPROFILE_DIR		:= $(BUILD_DIR)/oprofile-$(OPROFILE_VERSION)
OPROFILE_SITE		:= http://prdownloads.sourceforge.net/oprofile
OPROFILE_SOURCE		:= oprofile-$(OPROFILE_VERSION).tar.gz
OPROFILE_CAT		:= $(ZCAT)

OPROFILE_BINARIES	:= utils/ophelp
OPROFILE_BINARIES	+= pp/opannotate pp/oparchive pp/opgprof pp/opreport
OPROFILE_BINARIES	+= daemon/oprofiled

$(DL_DIR)/$(OPROFILE_SOURCE):
	$(WGET) -P $(DL_DIR) $(OPROFILE_SITE)/$(OPROFILE_SOURCE)

oprofile-source: $(DL_DIR)/$(OPROFILE_SOURCE)

$(OPROFILE_DIR)/.unpacked: $(DL_DIR)/$(OPROFILE_SOURCE)
	$(OPROFILE_CAT) $(DL_DIR)/$(OPROFILE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(OPROFILE_DIR) package/oprofile/ \*.patch*
	$(CONFIG_UPDATE) $(OPROFILE_DIR)
	touch $@

$(OPROFILE_DIR)/.configured: $(OPROFILE_DIR)/.unpacked
	(cd $(OPROFILE_DIR); rm -f config.cache;		\
		$(TARGET_CONFIGURE_OPTS)			\
		$(TARGET_CONFIGURE_ARGS)			\
		./configure					\
			--target=$(GNU_TARGET_NAME)		\
			--host=$(GNU_TARGET_NAME)		\
			--build=$(GNU_HOST_NAME)		\
			--prefix=/usr				\
			--sysconfdir=/etc			\
			--localstatedir=/var			\
			--includedir=/include			\
	);
	touch $@

$(OPROFILE_DIR)/daemon/oprofiled: $(OPROFILE_DIR)/.configured
	PATH=$(TARGET_PATH) $(MAKE) -C $(OPROFILE_DIR)
	touch -c $@

$(TARGET_DIR)/usr/bin/oprofiled: $(OPROFILE_DIR)/daemon/oprofiled
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/bin
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/share/oprofile/avr32
	$(INSTALL) -m 644 $(addprefix $(OPROFILE_DIR)/events/avr32/, events unit_masks) $(TARGET_DIR)/usr/share/oprofile/avr32
	$(INSTALL) -m 644 $(OPROFILE_DIR)/libregex/stl.pat $(TARGET_DIR)/usr/share/oprofile
	$(INSTALL) -m 755 $(OPROFILE_DIR)/utils/opcontrol $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 755 $(addprefix $(OPROFILE_DIR)/, $(OPROFILE_BINARIES)) $(TARGET_DIR)/usr/bin
	$(STRIP) --strip-unneeded $(addprefix $(TARGET_DIR)/usr/bin/, $(notdir $(OPROFILE_BINARIES)))
	touch -c $@

oprofile: uclibc popt binutils_target $(TARGET_DIR)/usr/bin/oprofiled

oprofile-clean:
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(notdir $(OPROFILE_BINARIES)))
	rm -f $(TARGET_DIR)/usr/bin/opcontrol
	rm -rf $(TARGET_DIR)/usr/share/oprofile
	-$(MAKE) -C $(OPROFILE_DIR) clean

oprofile-dirclean:
	rm -rf $(OPROFILE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_OPROFILE)),y)
TARGETS		+= oprofile
endif
