
.PHONY: target-host-info

target-host-info: $(TARGET_DIR)/etc/issue $(TARGET_DIR)/etc/hostname

$(TARGET_DIR)/etc/issue: .config
	mkdir -p $(TARGET_DIR)/etc
	echo "" > $(TARGET_DIR)/etc/issue
	echo "" >> $(TARGET_DIR)/etc/issue
	echo "$(BANNER)" >> $(TARGET_DIR)/etc/issue

$(TARGET_DIR)/etc/hostname: .config
	mkdir -p $(TARGET_DIR)/etc
	echo "$(TARGET_HOSTNAME)" > $(TARGET_DIR)/etc/hostname
