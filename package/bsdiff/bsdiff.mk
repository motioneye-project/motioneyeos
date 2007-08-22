#############################################################
#
# bsdiff
#
#############################################################
BSDIFF_VERSION:=4.3
BSDIFF_SOURCE:=bsdiff-$(BSDIFF_VERSION).tar.gz
BSDIFF_SITE:=http://www.daemonology.net/bsdiff
BSDIFF_DIR:=$(BUILD_DIR)/bsdiff-$(BSDIFF_VERSION)
BSDIFF_BINARY:=bsdiff
BSDIFF_TARGET_BINARY:=usr/bin/bsdiff
BSDIFF_ZCAT=$(ZCAT)

$(DL_DIR)/$(BSDIFF_SOURCE):
	$(WGET) -P $(DL_DIR) $(BSDIFF_SITE)/$(BSDIFF_SOURCE)

$(BSDIFF_DIR)/.source: $(DL_DIR)/$(BSDIFF_SOURCE)
	$(BSDIFF_ZCAT) $(DL_DIR)/$(BSDIFF_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(BSDIFF_DIR)/.source

$(BSDIFF_DIR)/$(BSDIFF_BINARY): $(BSDIFF_DIR)/.source
	(cd $(BSDIFF_DIR); \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CC) -L $(STAGING_DIR)/lib -lbz2 \
			$(TARGET_CFLAGS) bsdiff.c -o bsdiff; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CC) -L $(STAGING_DIR)/lib -lbz2 \
			$(TARGET_CFLAGS) bspatch.c -o bspatch; \
	)

$(TARGET_DIR)/$(BSDIFF_TARGET_BINARY): $(BSDIFF_DIR)/$(BSDIFF_BINARY)
	cp -dpf $(BSDIFF_DIR)/bsdiff $(TARGET_DIR)/usr/bin/.
	cp -dpf $(BSDIFF_DIR)/bspatch $(TARGET_DIR)/usr/bin/.

bsdiff: uclibc bzip2 $(TARGET_DIR)/$(BSDIFF_TARGET_BINARY)

bsdiff-source: $(DL_DIR)/$(BSDIFF_SOURCE)

bsdiff-clean:
	-rm $(TARGET_DIR)/usr/bin/{bsdiff,bspatch}
	-rm $(BSDIFF_DIR)/{bsdiff,bspatch}

bsdiff-dirclean:
	rm -rf $(BSDIFF_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_BSDIFF)),y)
TARGETS+=bsdiff
endif
