#############################################################
#
# Build the jffs2 root filesystem image
#
#############################################################

JFFS2_OPTS := -e $(strip $(BR2_TARGET_ROOTFS_JFFS2_EBSIZE))

ifeq ($(strip $(BR2_TARGET_ROOTFS_JFFS2_PAD)),y)
JFFS2_OPTS += -p
ifneq ($(strip $(BR2_TARGET_ROOTFS_JFFS2_PADSIZE)),0x0)
JFFS2_OPTS += $(strip $(BR2_TARGET_ROOTFS_JFFS2_PADSIZE))
endif
endif

ifeq ($(strip $(BR2_TARGET_ROOTFS_JFFS2_SQUASH)),y)
JFFS2_OPTS += -q
endif

ifeq ($(strip $(BR2_TARGET_ROOTFS_JFFS2_LE)),y)
JFFS2_OPTS += -l
endif

ifeq ($(strip $(BR2_TARGET_ROOTFS_JFFS2_BE)),y)
JFFS2_OPTS += -b
endif

JFFS2_DEVFILE = $(strip $(subst ",,$(BR2_TARGET_ROOTFS_JFFS2_DEVFILE)))
ifneq ($(JFFS2_DEVFILE),)
JFFS2_OPTS += -D $(TARGET_DEVICE_TABLE)
endif

JFFS2_TARGET := $(subst ",,$(BR2_TARGET_ROOTFS_JFFS2_OUTPUT))

#
# mtd-host is a dependency which builds a local copy of mkfs.jffs2 if it's needed.
# the actual build is done from package/mtd/mtd.mk and it sets the
# value of MKFS_JFFS2 to either the previously installed copy or the one
# just built.
#
$(JFFS2_TARGET): mtd-host
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true;
	@rm -rf $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/share/man
	@rm -rf $(TARGET_DIR)/usr/info
	$(MKFS_JFFS2) \
		$(JFFS2_OPTS) \
		-d $(BUILD_DIR)/root \
		-o $(JFFS2_TARGET) \
		-D $(TARGET_DEVICE_TABLE)
	@ls -l $(JFFS2_TARGET)

JFFS2_COPYTO := $(strip $(subst ",,$(BR2_TARGET_ROOTFS_JFFS2_COPYTO)))

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
