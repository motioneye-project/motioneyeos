#############################################################
#
# makedevs
#
#############################################################

MAKEDEVS_DIR=$(BUILD_DIR)/makedevs

$(MAKEDEVS_DIR)/makedevs.c:
	rm -rf $(MAKEDEVS_DIR)
	mkdir $(MAKEDEVS_DIR)
	cp package/makedevs/makedevs.c $(MAKEDEVS_DIR)

$(MAKEDEVS_DIR)/makedevs: $(MAKEDEVS_DIR)/makedevs.c
	$(CC) -Wall -Werror -O2 $(MAKEDEVS_DIR)/makedevs.c -o $@

$(TARGET_DIR)/usr/bin/makedevs: $(MAKEDEVS_DIR)/makedevs
	$(INSTALL) -m 755 $^ $@

makedevs: $(TARGET_DIR)/usr/bin/makedevs
makedevs-source:

HOST_MAKEDEVS_DIR=$(BUILD_DIR)/host-makedevs

$(HOST_MAKEDEVS_DIR)/makedevs.c:
	rm -rf $(HOST_MAKEDEVS_DIR)
	mkdir $(HOST_MAKEDEVS_DIR)
	cp package/makedevs/makedevs.c $(HOST_MAKEDEVS_DIR)

$(HOST_MAKEDEVS_DIR)/makedevs: $(HOST_MAKEDEVS_DIR)/makedevs.c
	$(CC) -Wall -Werror -O2 $(HOST_MAKEDEVS_DIR)/makedevs.c -o $@

$(HOST_DIR)/usr/bin/makedevs: $(HOST_MAKEDEVS_DIR)/makedevs
	$(INSTALL) -m 755 $^ $@

host-makedevs: $(HOST_DIR)/usr/bin/makedevs
host-makedevs-source:
