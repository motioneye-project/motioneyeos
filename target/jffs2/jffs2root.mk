#############################################################
#
# Build the jffs2 root filesystem image
#
#############################################################

JFFS2_OPTS := -e $(strip $(BR2_TARGET_ROOTFS_JFFS2_EBSIZE))

ifeq ($(strip $(BR2_TARGET_ROOTFS_JFFS2_PAD)),y)
ifneq ($(strip $(BR2_TARGET_ROOTFS_JFFS2_PADSIZE)),0x0)
JFFS2_OPTS += --pad=$(strip $(BR2_TARGET_ROOTFS_JFFS2_PADSIZE))
else
JFFS2_OPTS += -p
endif
endif

ifeq ($(BR2_TARGET_ROOTFS_JFFS2_SQUASH),y)
JFFS2_OPTS += -q
endif

ifeq ($(BR2_TARGET_ROOTFS_JFFS2_LE),y)
JFFS2_OPTS += -l
endif

ifeq ($(BR2_TARGET_ROOTFS_JFFS2_BE),y)
JFFS2_OPTS += -b
endif

ifneq ($(BR2_TARGET_ROOTFS_JFFS2_DEFAULT_PAGESIZE),y)
JFFS2_OPTS += -s $(BR2_TARGET_ROOTFS_JFFS2_PAGESIZE)
ifeq ($(BR2_TARGET_ROOTFS_JFFS2_NOCLEANMARKER),y)
JFFS2_OPTS += -n
endif
endif

JFFS2_TARGET := $(strip $(subst ",,$(BR2_TARGET_ROOTFS_JFFS2_OUTPUT)))
#"))
JFFS2_DEVFILE = $(strip $(subst ",,$(BR2_TARGET_ROOTFS_JFFS2_DEVFILE)))
#"))
ifneq ($(JFFS2_DEVFILE)$(TARGET_DEVICE_TABLE),)
JFFS2_OPTS += -D $(TARGET_DEVICE_TABLE)
endif


#
# mtd-host is a dependency which builds a local copy of mkfs.jffs2 if it is needed.
# the actual build is done from package/mtd/mtd.mk and it sets the
# value of MKFS_JFFS2 to either the previously installed copy or the one
# just built.
#
$(JFFS2_TARGET): host-fakeroot makedevs mtd-host
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true;
	@rm -rf $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/share/man
	@rm -rf $(TARGET_DIR)/usr/info
	-/sbin/ldconfig -r $(TARGET_DIR) 2>/dev/null
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(JFFS2_TARGET))
	touch $(STAGING_DIR)/.fakeroot.00000
	cat $(STAGING_DIR)/.fakeroot* > $(STAGING_DIR)/_fakeroot.$(notdir $(JFFS2_TARGET))
	echo "chown -R root:root $(TARGET_DIR)" >> $(STAGING_DIR)/_fakeroot.$(notdir $(JFFS2_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(JFFS2_TARGET))
endif
	# Use fakeroot so mkfs.jffs2 believes the previous fakery
	echo "$(MKFS_JFFS2) $(JFFS2_OPTS) -d $(BUILD_DIR)/root -o $(JFFS2_TARGET)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(JFFS2_TARGET))
	chmod a+x $(STAGING_DIR)/_fakeroot.$(notdir $(JFFS2_TARGET))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(STAGING_DIR)/_fakeroot.$(notdir $(JFFS2_TARGET))
	-@rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(JFFS2_TARGET))
	@ls -l $(JFFS2_TARGET)

JFFS2_COPYTO := $(strip $(subst ",,$(BR2_TARGET_ROOTFS_JFFS2_COPYTO)))
#"))

jffs2root: $(JFFS2_TARGET)
ifneq ($(JFFS2_COPYTO),)
	@cp -f $(JFFS2_TARGET) $(JFFS2_COPYTO)
endif

jffs2root-source: mtd-host-source

jffs2root-clean: mtd-host-clean
	-rm -f $(JFFS2_TARGET)

jffs2root-dirclean: mtd-host-dirclean
	-rm -f $(JFFS2_TARGET)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_TARGET_ROOTFS_JFFS2)),y)
TARGETS+=jffs2root
endif
