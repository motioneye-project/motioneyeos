#############################################################
#
# netcat
#
#############################################################

NETCAT_VERSION=0.7.1
NETCAT_SOURCE=netcat-$(NETCAT_VERSION).tar.gz
NETCAT_CAT:=$(ZCAT)
NETCAT_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/netcat
NETCAT_DIR:=$(BUILD_DIR)/netcat-$(NETCAT_VERSION)
NETCAT_BINARY:=src/netcat
NETCAT_TARGET_BINARY:=sbin/netcat

$(DL_DIR)/$(NETCAT_SOURCE):
	$(WGET) -P $(DL_DIR) $(NETCAT_SITE)/$(NETCAT_SOURCE)

netcat-source: $(DL_DIR)/$(NETCAT_SOURCE)

$(NETCAT_DIR)/.unpacked: $(DL_DIR)/$(NETCAT_SOURCE)
	$(NETCAT_CAT) $(DL_DIR)/$(NETCAT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(NETCAT_DIR)/.configured: $(NETCAT_DIR)/.unpacked
	(cd $(NETCAT_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
	);
	touch $@


$(NETCAT_DIR)/$(NETCAT_BINARY): $(NETCAT_DIR)/.configured
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(NETCAT_DIR)

$(TARGET_DIR)/$(NETCAT_TARGET_BINARY): $(NETCAT_DIR)/$(NETCAT_BINARY)
	install -D $(NETCAT_DIR)/$(NETCAT_BINARY) $(TARGET_DIR)/$(NETCAT_TARGET_BINARY)
	$(STRIP) -s $@

netcat: uclibc $(TARGET_DIR)/$(NETCAT_TARGET_BINARY)

netcat-clean:
	rm -f $(TARGET_DIR)/$(NETCAT_TARGET_BINARY)
	-$(MAKE) -C $(NETCAT_DIR) clean
netcat-dirclean:
	rm -rf $(NETCAT_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_NETCAT)),y)
TARGETS+=netcat
endif
