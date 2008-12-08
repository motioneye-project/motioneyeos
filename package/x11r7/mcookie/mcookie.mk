#############################################################
#
# mcookie
#
#############################################################

$(TARGET_DIR)/usr/bin/mcookie: package/x11r7/mcookie/mcookie.c
	$(TARGET_CC) -Wall -Os -s package/x11r7/mcookie/mcookie.c -o $(TARGET_DIR)/usr/bin/mcookie


mcookie: $(TARGET_DIR)/usr/bin/mcookie

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_MCOOKIE),y)
TARGETS+=mcookie
endif
