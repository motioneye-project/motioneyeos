#############################################################
#
# ethtool
#
#############################################################

ETHTOOL_VERSION=3
ETHTOOL_SOURCE=ethtool-$(ETHTOOL_VERSION).tar.gz
ETHTOOL_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/gkernel/
ETHTOOL_DIR=$(BUILD_DIR)/ethtool-$(ETHTOOL_VERSION)
ETHTOOL_CAT:=$(ZCAT)

$(DL_DIR)/$(ETHTOOL_SOURCE):
	$(WGET) -P $(DL_DIR) $(ETHTOOL_SITE)/$(ETHTOOL_SOURCE)

$(ETHTOOL_DIR)/.unpacked: $(DL_DIR)/$(ETHTOOL_SOURCE)
	$(ETHTOOL_CAT) $(DL_DIR)/$(ETHTOOL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(ETHTOOL_DIR)/.configured: $(ETHTOOL_DIR)/.unpacked
	(cd $(ETHTOOL_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
	);
	touch $@

$(ETHTOOL_DIR)/ethtool: $(ETHTOOL_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(ETHTOOL_DIR)

$(ETHTOOL_DIR)/.installed: $(ETHTOOL_DIR)/ethtool
	cp $(ETHTOOL_DIR)/ethtool $(TARGET_DIR)/usr/sbin
	touch $@

ethtool:	uclibc $(ETHTOOL_DIR)/.installed

ethtool-source: $(DL_DIR)/$(ETHTOOL_SOURCE)

ethtool-clean:
	-$(MAKE) -C $(ETHTOOL_DIR) clean

ethtool-dirclean:
	rm -rf $(ETHTOOL_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_ETHTOOL)),y)
TARGETS+=ethtool
endif
