#############################################################
#
# dash
#
#############################################################
DASH_VERSION:=0.5.3
DASH_SOURCE:=dash_$(DASH_VERSION).orig.tar.gz
DASH_SITE:=http://ftp.debian.org/debian/pool/main/d/dash
DASH_CAT:=$(ZCAT)
DASH_DIR:=$(BUILD_DIR)/dash-$(DASH_VERSION)
DASH_PATCH1:=dash_$(DASH_VERSION)-7.diff.gz
DASH_BINARY:=src/dash
DASH_TARGET_BINARY:=bin/dash

$(DL_DIR)/$(DASH_SOURCE):
	$(WGET) -P $(DL_DIR) $(DASH_SITE)/$(DASH_SOURCE)

$(DL_DIR)/$(DASH_PATCH1):
	$(WGET) -P $(DL_DIR) $(DASH_SITE)/$(DASH_PATCH1)

dash-source: $(DL_DIR)/$(DASH_SOURCE) $(DL_DIR)/$(DASH_PATCH1)

$(DASH_DIR)/.unpacked: $(DL_DIR)/$(DASH_SOURCE) $(DL_DIR)/$(DASH_PATCH1)
	$(DASH_CAT) $(DL_DIR)/$(DASH_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(ZCAT) $(DL_DIR)/$(DASH_PATCH1) | patch -p1 -d $(DASH_DIR)
	touch $(DASH_DIR)/.unpacked

$(DASH_DIR)/.configured: $(DASH_DIR)/.unpacked
	(cd $(DASH_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
	)
	touch $(DASH_DIR)/.configured

$(DASH_DIR)/$(DASH_BINARY): $(DASH_DIR)/.configured
	$(MAKE1) CC=$(TARGET_CC) CC_FOR_BUILD="$(HOSTCC)" -C $(DASH_DIR)
	touch -c $(DASH_DIR)/$(DASH_BINARY)

$(TARGET_DIR)/$(DASH_TARGET_BINARY): $(DASH_DIR)/$(DASH_BINARY)
	cp -a $(DASH_DIR)/$(DASH_BINARY) $(TARGET_DIR)/$(DASH_TARGET_BINARY)
	touch -c $(TARGET_DIR)/$(DASH_TARGET_BINARY)

dash: uclibc $(TARGET_DIR)/$(DASH_TARGET_BINARY)

dash-clean:
	$(MAKE1) CC=$(TARGET_CC) -C $(DASH_DIR) clean
	rm -f $(TARGET_DIR)/$(DASH_TARGET_BINARY)

dash-dirclean:
	rm -rf $(DASH_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DASH)),y)
TARGETS+=dash
endif
