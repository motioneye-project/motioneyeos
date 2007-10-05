#############################################################
#
# cpio to archive target filesystem
#
#############################################################

CPIO_BASE:=$(IMAGE).cpio

CPIO_ROOTFS_COMPRESSOR:=
CPIO_ROOTFS_COMPRESSOR_EXT:=
CPIO_ROOTFS_COMPRESSOR_PREREQ:=
ifeq ($(BR2_TARGET_ROOTFS_CPIO_GZIP),y)
CPIO_ROOTFS_COMPRESSOR:=gzip -9 -c
CPIO_ROOTFS_COMPRESSOR_EXT:=gz
#CPIO_ROOTFS_COMPRESSOR_PREREQ:= gzip-host
endif
ifeq ($(BR2_TARGET_ROOTFS_CPIO_BZIP2),y)
CPIO_ROOTFS_COMPRESSOR:=bzip2 -9 -c
CPIO_ROOTFS_COMPRESSOR_EXT:=bz2
#CPIO_ROOTFS_COMPRESSOR_PREREQ:= bzip2-host
endif
ifeq ($(BR2_TARGET_ROOTFS_CPIO_LZMA),y)
CPIO_ROOTFS_COMPRESSOR:=lzma -9 -c
CPIO_ROOTFS_COMPRESSOR_EXT:=lzma
CPIO_ROOTFS_COMPRESSOR_PREREQ:= lzma-host
endif

ifneq ($(CPIO_ROOTFS_COMPRESSOR),)
CPIO_TARGET := $(CPIO_BASE).$(CPIO_ROOTFS_COMPRESSOR_EXT)
else
CPIO_TARGET := $(CPIO_BASE)
endif

ROOTFS_CPIO_COPYTO:=$(strip $(subst ",,$(BR2_TARGET_ROOTFS_CPIO_COPYTO)))
# "))
#

cpioroot-init:
	rm -f $(TARGET_DIR)/init
	ln -s sbin/init $(TARGET_DIR)/init

$(CPIO_BASE): host-fakeroot makedevs cpioroot-init
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIPCMD) 2>/dev/null || true
ifneq ($(BR2_HAVE_MANPAGES),y)
	@rm -rf $(TARGET_DIR)/usr/man
endif
ifneq ($(BR2_HAVE_INFOPAGES),y)
	@rm -rf $(TARGET_DIR)/usr/info
endif
	$(if $(TARGET_LDCONFIG),test -x $(TARGET_LDCONFIG) && $(TARGET_LDCONFIG) -r $(TARGET_DIR) 2>/dev/null)
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(TAR_TARGET))
	touch $(PROJECT_BUILD_DIR)/.fakeroot.00000
	cat $(PROJECT_BUILD_DIR)/.fakeroot* > $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CPIO_BASE))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CPIO_BASE))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CPIO_BASE))
endif
	# Use fakeroot so tar believes the previous fakery
	echo "cd $(TARGET_DIR) && find . | cpio --quiet -o -H newc > $(CPIO_BASE)" \
		>> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CPIO_BASE))
	chmod a+x $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CPIO_BASE))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CPIO_BASE))
	#-@rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CPIO_BASE))
ifeq ($(CPIO_ROOTFS_COMPRESSOR),)
ifneq ($(ROOTFS_CPIO_COPYTO),)
	$(Q)cp -f $(CPIO_BASE) $(ROOTFS_CPIO_COPYTO)
endif
endif

ifneq ($(CPIO_ROOTFS_COMPRESSOR),)
$(CPIO_BASE).$(CPIO_ROOTFS_COMPRESSOR_EXT): $(CPIO_ROOTFS_COMPRESSOR_PREREQ) $(CPIO_BASE)
	$(CPIO_ROOTFS_COMPRESSOR) $(CPIO_BASE) > $(CPIO_TARGET)
ifneq ($(ROOTFS_CPIO_COPYTO),)
	$(Q)cp -f $(CPIO_BASE).$(CPIO_ROOTFS_COMPRESSOR_EXT) $(ROOTFS_CPIO_COPYTO).$(CPIO_ROOTFS_COMPRESSOR_EXT)
endif
endif

cpioroot: $(CPIO_TARGET)

cpioroot-source:

cpioroot-clean:

cpioroot-dirclean:

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_TARGET_ROOTFS_CPIO)),y)
TARGETS+=cpioroot
endif
