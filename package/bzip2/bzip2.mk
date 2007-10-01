#############################################################
#
# bzip2
#
#############################################################
BZIP2_VERSION:=1.0.4
BZIP2_SOURCE:=bzip2-$(BZIP2_VERSION).tar.gz
BZIP2_SITE:=http://www.bzip.org/$(BZIP2_VERSION)
BZIP2_DIR:=$(BUILD_DIR)/bzip2-$(BZIP2_VERSION)
BZIP2_CAT:=$(ZCAT)
BZIP2_BINARY:=$(BZIP2_DIR)/bzip2
BZIP2_TARGET_BINARY:=$(TARGET_DIR)/usr/bin/bzmore

$(DL_DIR)/$(BZIP2_SOURCE):
	 $(WGET) -P $(DL_DIR) $(BZIP2_SITE)/$(BZIP2_SOURCE)

bzip2-source: $(DL_DIR)/$(BZIP2_SOURCE)

$(BZIP2_DIR)/.unpacked: $(DL_DIR)/$(BZIP2_SOURCE)
	$(BZIP2_CAT) $(DL_DIR)/$(BZIP2_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(SED) "s,ln \$$(,ln -snf \$$(,g" $(BZIP2_DIR)/Makefile
	$(SED) "s,ln -s (lib.*),ln -snf \$$1; ln -snf libbz2.so.$(BZIP2_VERSION) \
	    libbz2.so,g" $(BZIP2_DIR)/Makefile-libbz2_so
ifneq ($(BR2_LARGEFILE),y)
	$(SED) "s,^BIGFILES,#BIGFILES,g" $(BZIP2_DIR)/Makefile
	$(SED) "s,^BIGFILES,#BIGFILES,g" $(BZIP2_DIR)/Makefile-libbz2_so
endif
	$(SED) "s:-O2:$(TARGET_CFLAGS):" $(BZIP2_DIR)/Makefile
	$(SED) "s:-O2:$(TARGET_CFLAGS):" $(BZIP2_DIR)/Makefile-libbz2_so
	touch $@

$(STAGING_DIR)/lib/libbz2.so.$(BZIP2_VERSION): $(BZIP2_DIR)/.unpacked
	$(TARGET_CONFIGURE_OPTS) \
	$(MAKE) CC=$(TARGET_CC) RANLIB=$(TARGET_RANLIB) AR=$(TARGET_AR) \
		-C $(BZIP2_DIR) -f Makefile-libbz2_so
	$(TARGET_CONFIGURE_OPTS) \
	$(MAKE) CC=$(TARGET_CC) RANLIB=$(TARGET_RANLIB) AR=$(TARGET_AR) \
		-C $(BZIP2_DIR) libbz2.a
	cp $(BZIP2_DIR)/bzlib.h $(STAGING_DIR)/usr/include/
	cp $(BZIP2_DIR)/libbz2.so.$(BZIP2_VERSION) $(STAGING_DIR)/lib/
	cp $(BZIP2_DIR)/libbz2.a $(STAGING_DIR)/usr/lib/
	(cd $(STAGING_DIR)/usr/lib/; \
		ln -snf ../../lib/libbz2.so.$(BZIP2_VERSION) libbz2.so; \
	)
	(cd $(STAGING_DIR)/lib; \
		ln -snf libbz2.so.$(BZIP2_VERSION) libbz2.so.1.0; \
		ln -snf libbz2.so.$(BZIP2_VERSION) libbz2.so.1; \
	)

$(BZIP2_BINARY): $(STAGING_DIR)/lib/libbz2.so.$(BZIP2_VERSION)
	$(TARGET_CONFIGURE_OPTS) \
	$(MAKE) CC=$(TARGET_CC) -C $(BZIP2_DIR) bzip2 bzip2recover
	touch -c $@

$(BZIP2_TARGET_BINARY): $(BZIP2_BINARY)
	(cd $(TARGET_DIR)/usr/bin; \
		rm -f bzip2 bunzip2 bzcat bzip2recover \
			bzgrep bzegrep bzfgrep bzmore bzless bzdiff bzcmp; \
	)
	$(TARGET_CONFIGURE_OPTS) \
	$(MAKE) PREFIX=$(TARGET_DIR)/usr -C $(BZIP2_DIR) install
	rm -f $(TARGET_DIR)/usr/lib/libbz2.a
	rm -f $(TARGET_DIR)/usr/include/bzlib.h
	cp $(BZIP2_DIR)/libbz2.so.$(BZIP2_VERSION) $(TARGET_DIR)/usr/lib/
	(cd $(TARGET_DIR)/usr/lib; \
		ln -snf libbz2.so.$(BZIP2_VERSION) libbz2.so.1.0; \
		ln -snf libbz2.so.$(BZIP2_VERSION) libbz2.so; \
	)
	(cd $(TARGET_DIR)/usr/bin; \
		ln -snf bzip2 bunzip2; \
		ln -snf bzip2 bzcat; \
		ln -snf bzdiff bzcmp; \
		ln -snf bzmore bzless; \
		ln -snf bzgrep bzegrep; \
		ln -snf bzgrep bzfgrep; \
	)
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(TARGET_DIR)/usr/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/man
endif
	rm -rf $(TARGET_DIR)/share/locale
	rm -rf $(TARGET_DIR)/usr/share/doc

$(TARGET_DIR)/usr/lib/libbz2.a: $(STAGING_DIR)/lib/libbz2.a
	mkdir -p $(TARGET_DIR)/usr/include
	cp $(STAGING_DIR)/usr/include/bzlib.h $(TARGET_DIR)/usr/include/
	cp $(STAGING_DIR)/lib/libbz2.a $(TARGET_DIR)/usr/lib/
	rm -f $(TARGET_DIR)/lib/libbz2.so
	(cd $(TARGET_DIR)/usr/lib; \
		ln -fs /usr/lib/libbz2.so.1.0 libbz2.so; \
	)
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libbz2.so.1.0
	touch -c $@

bzip2-headers: $(TARGET_DIR)/usr/lib/libbz2.a

bzip2: uclibc $(BZIP2_TARGET_BINARY)

bzip2-clean:
	rm -f $(addprefix $(TARGET_DIR),/lib/libbz2.* \
					/usr/lib/libbz2.* \
					/usr/include/bzlib.h)
	rm -f $(addprefix $(STAGING_DIR),/lib/libbz2.* \
					/usr/lib/libbz2.* \
					/usr/include/bzlib.h)
	-$(MAKE) -C $(BZIP2_DIR) clean

bzip2-dirclean:
	rm -rf $(BZIP2_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_BZIP2)),y)
TARGETS+=bzip2
endif
