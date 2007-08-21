#############################################################
#
# stunnel
#
#############################################################
STUNNEL_VERSION:=4.16
STUNNEL_SOURCE:=stunnel-$(STUNNEL_VERSION).tar.gz
STUNNEL_SITE:=http://www.stunnel.org/download/stunnel/src
STUNNEL_CAT:=$(ZCAT)
STUNNEL_DIR:=$(BUILD_DIR)/stunnel-$(STUNNEL_VERSION)

$(DL_DIR)/$(STUNNEL_SOURCE):
	 $(WGET) -P $(DL_DIR) $(STUNNEL_SITE)/$(STUNNEL_SOURCE)

stunnel-source: $(DL_DIR)/$(STUNNEL_SOURCE)

$(STUNNEL_DIR)/.unpacked: $(DL_DIR)/$(STUNNEL_SOURCE)
	$(STUNNEL_CAT) $(DL_DIR)/$(STUNNEL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(STUNNEL_DIR)
	toolchain/patch-kernel.sh $(STUNNEL_DIR) package/stunnel stunnel\*.patch
	touch $(STUNNEL_DIR)/*
	touch $(STUNNEL_DIR)/.unpacked

$(STUNNEL_DIR)/.configured: $(STUNNEL_DIR)/.unpacked
	(cd $(STUNNEL_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_file___dev_ptmx_=yes \
		ac_cv_file___dev_ptc_=no \
		./configure \
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
		--with-random=/dev/urandom \
		--disable-libwrap \
		--with-ssl=$(STAGING_DIR) \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	)
	touch $(STUNNEL_DIR)/.configured

$(STUNNEL_DIR)/src/stunnel: $(STUNNEL_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(STUNNEL_DIR)

$(TARGET_DIR)/usr/bin/stunnel: $(STUNNEL_DIR)/src/stunnel
	install -c $(STUNNEL_DIR)/src/stunnel $(TARGET_DIR)/usr/bin/stunnel
	$(STRIP) $(TARGET_DIR)/usr/bin/stunnel > /dev/null 2>&1
ifeq ($(strip $(BR2_CROSS_TOOLCHAIN_TARGET_UTILS)),y)
	mkdir -p $(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/target_utils
	install -c $(TARGET_DIR)/usr/bin/stunnel \
		$(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/target_utils/stunnel
endif

stunnel: uclibc $(TARGET_DIR)/usr/bin/stunnel 

stunnel-clean: 
	$(MAKE) -C $(STUNNEL_DIR) clean

stunnel-dirclean: 
	rm -rf $(STUNNEL_DIR) 


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_STUNNEL)),y)
TARGETS+=stunnel
endif
