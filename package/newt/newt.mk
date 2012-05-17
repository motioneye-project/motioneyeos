#############################################################
#
# newt
#
#############################################################
NEWT_SOURCE=newt-0.51.0.tar.bz2
NEWT_CAT:=$(BZCAT)
NEWT_SITE=http://www.uclibc.org/
NEWT_DIR=$(BUILD_DIR)/newt-0.51.0
NEWT_VERSION=0.51.0
NEWT_CFLAGS=-Os -g -fPIC

$(DL_DIR)/$(NEWT_SOURCE):
	$(call DOWNLOAD,$(NEWT_SITE)/$(NEWT_SOURCE))

$(NEWT_DIR)/.source: $(DL_DIR)/$(NEWT_SOURCE)
	$(NEWT_CAT) $(DL_DIR)/$(NEWT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(NEWT_DIR)/.source

$(NEWT_DIR)/.configured: $(NEWT_DIR)/.source
	(cd $(NEWT_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CFLAGS="$(TARGET_CFLAGS) $(NEWT_CFLAGS)" \
		./configure $(QUIET) \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_NLS) \
	)
	touch $(NEWT_DIR)/.configured

$(NEWT_DIR)/libnewt.so.$(NEWT_VERSION): $(NEWT_DIR)/.configured
	$(MAKE1) CFLAGS="$(TARGET_CFLAGS) $(NEWT_CFLAGS)" CC="$(TARGET_CC)" -C $(NEWT_DIR)
	touch -c $@

$(STAGING_DIR)/usr/lib/libnewt.a: $(NEWT_DIR)/libnewt.so.$(NEWT_VERSION)
	cp -a $(NEWT_DIR)/libnewt.a $(STAGING_DIR)/usr/lib/
	cp -a $(NEWT_DIR)/newt.h $(STAGING_DIR)/usr/include/
	cp -a $(NEWT_DIR)/libnewt.so* $(STAGING_DIR)/usr/lib/
	(cd $(STAGING_DIR)/usr/lib; ln -fs libnewt.so.$(NEWT_VERSION) libnewt.so)
	(cd $(STAGING_DIR)/usr/lib; ln -fs libnewt.so.$(NEWT_VERSION) libnewt.so.0.51)
	touch -c $@

$(TARGET_DIR)/usr/lib/libnewt.so.$(NEWT_VERSION): $(STAGING_DIR)/usr/lib/libnewt.a
	cp -a $(STAGING_DIR)/usr/lib/libnewt.so* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libnewt.so*
	touch -c $@

newt-legal-info:
	@$(call legal-warning-pkg,newt,legal-info not yet implemented)

newt: slang $(TARGET_DIR)/usr/lib/libnewt.so.$(NEWT_VERSION)

newt-source: $(DL_DIR)/$(NEWT_SOURCE)

newt-clean:
	rm -f $(TARGET_DIR)/usr/lib/libnewt.so*
	-$(MAKE) -C $(NEWT_DIR) clean

newt-dirclean: slang-dirclean
	rm -rf $(NEWT_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_NEWT),y)
TARGETS+=newt
endif
