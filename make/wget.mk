#############################################################
#
# wget
#
#############################################################
WGET_VER:=1.9.1
WGET_SOURCE:=wget-$(WGET_VER).tar.gz
WGET_SITE:=ftp://mirrors.kernel.org/gnu/wget
WGET_DIR:=$(BUILD_DIR)/wget-$(WGET_VER)
WGET_CAT:=zcat
WGET_BINARY:=src/wget
WGET_TARGET_BINARY:=bin/wget

$(DL_DIR)/$(WGET_SOURCE):
	$(WGET) -P $(DL_DIR) $(WGET_SITE)/$(WGET_SOURCE)

$(WGET_DIR)/.unpacked: $(DL_DIR)/$(WGET_SOURCE)
	$(WGET_CAT) $(DL_DIR)/$(WGET_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(WGET_DIR)/.unpacked

$(WGET_DIR)/.configured: $(WGET_DIR)/.unpacked
	(cd $(WGET_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) CC_FOR_BUILD=$(HOSTCC) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		--disable-ipv6 \
		$(DISABLE_NLS) \
		--without-ssl \
	);
	touch $(WGET_DIR)/.configured

$(WGET_DIR)/$(WGET_BINARY): $(WGET_DIR)/.configured
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(WGET_DIR)

$(TARGET_DIR)/$(WGET_TARGET_BINARY): $(WGET_DIR)/$(WGET_BINARY)
	install -D $(WGET_DIR)/$(WGET_BINARY) $(TARGET_DIR)/$(WGET_TARGET_BINARY)

wget: uclibc $(TARGET_DIR)/$(WGET_TARGET_BINARY)

wget-clean:
	rm -f $(TARGET_DIR)/$(WGET_TARGET_BINARY)
	-$(MAKE) -C $(WGET_DIR) clean

wget-dirclean:
	rm -rf $(WGET_DIR)
