#############################################################
#
# tar to archive target filesystem
#
#############################################################

TAR_OPTS := $(strip $(BR2_TARGET_ROOTFS_TAR_OPTIONS))

TAR_TARGET := $(IMAGE).tar

$(TAR_TARGET):
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true;
	@rm -rf $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/share/man
	@rm -rf $(TARGET_DIR)/usr/info
	tar -c$(TAR_OPTS)f $(TAR_TARGET) -C $(TARGET_DIR) .
		
tarroot: $(TAR_TARGET)
	@ls -l $(TAR_TARGET)

tarroot-source:

tarroot-clean:

tarroot-dirclean:
