#############################################################
#
# ethtool
#
#############################################################

ETHTOOL_VERSION=3
ETHTOOL_SOURCE=ethtool-$(ETHTOOL_VERSION).tar.gz
ETHTOOL_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/gkernel/
ETHTOOL_DIR=$(BUILD_DIR)/${shell basename $(ETHTOOL_SOURCE) .tar.gz}
ETHTOOL_WORKDIR=$(BUILD_DIR)/ethtool-$(ETHTOOL_VERSION)
ETHTOOL_CAT:=zcat

$(DL_DIR)/$(ETHTOOL_SOURCE):
	$(WGET) -P $(DL_DIR) $(ETHTOOL_SITE)/$(ETHTOOL_SOURCE)

$(ETHTOOL_DIR)/.unpacked: $(DL_DIR)/$(ETHTOOL_SOURCE)
	$(ETHTOOL_CAT) $(DL_DIR)/$(ETHTOOL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(ETHTOOL_DIR)/.unpacked

$(ETHTOOL_DIR)/.configured: $(ETHTOOL_DIR)/.unpacked
	(cd $(ETHTOOL_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
	);
	touch $(ETHTOOL_DIR)/.configured

$(ETHTOOL_WORKDIR)/ethtool: $(ETHTOOL_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(ETHTOOL_WORKDIR)

$(ETHTOOL_WORKDIR)/.installed: $(ETHTOOL_WORKDIR)/ethtool
	cp $(ETHTOOL_WORKDIR)/ethtool $(TARGET_DIR)/usr/sbin
	touch $(ETHTOOL_WORKDIR)/.installed

ethtool:	uclibc $(ETHTOOL_WORKDIR)/.installed

ethtool-source: $(DL_DIR)/$(ETHTOOL_SOURCE)

ethtool-clean:
	@if [ -d $(ETHTOOL_WORKDIR)/Makefile ] ; then \
		$(MAKE) -C $(ETHTOOL_WORKDIR) clean ; \
	fi;

ethtool-dirclean:
	rm -rf $(ETHTOOL_DIR) $(ETHTOOL_WORKDIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_ETHTOOL)),y)
TARGETS+=ethtool
endif
