#############################################################
#
# mcookie
#
#############################################################

$(TARGET_DIR)/usr/bin/mcookie: package/xorg/mcookie.c
	$(TARGET_CC) -Wall -Os -s package/xorg/mcookie.c -o $(TARGET_DIR)/usr/bin/mcookie


mcookie: $(TARGET_DIR)/usr/bin/mcookie

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MCOOKIE)),y)
TARGETS+=mcookie
endif
