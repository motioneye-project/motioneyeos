#############################################################
#
# devmem2
#
#############################################################

DEVMEM2_SOURCE:=devmem2.c
DEVMEM2_SITE:=http://free-electrons.com/pub/mirror
DEVMEM2_BINARY:=devmem2
DEVMEM2_DIR:=$(BUILD_DIR)/devmem2

$(DL_DIR)/$(DEVMEM2_SOURCE):
	$(WGET) -P $(DL_DIR) $(DEVMEM2_SITE)/$(DEVMEM2_SOURCE)

$(DEVMEM2_DIR)/$(DEVMEM2_SOURCE): $(DL_DIR)/$(DEVMEM2_SOURCE)
	mkdir -p $(@D)
	cp $^ $@

$(DEVMEM2_DIR)/$(DEVMEM2_BINARY): $(DEVMEM2_DIR)/$(DEVMEM2_SOURCE)
	$(TARGET_CC) $(TARGET_CFLAGS) -o $@ $^

$(TARGET_DIR)/sbin/$(DEVMEM2_BINARY): $(DEVMEM2_DIR)/$(DEVMEM2_BINARY)
	cp $^ $@
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $@

devmem2: uclibc $(TARGET_DIR)/sbin/$(DEVMEM2_BINARY)

devmem2-source: $(DL_DIR)/$(DEVMEM2_SOURCE)

devmem2-clean:
	rm -f $(TARGET_DIR/sbin/$(DEVMEM2_BINARY)

devmem2-dirclean:
	rm -rf $(DEVMEM2_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_DEVMEM2),y)
TARGETS+=devmem2
endif
