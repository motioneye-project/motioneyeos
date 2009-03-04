#############################################################
#
# iproute2
#
#############################################################
IPROUTE2_VERSION:=2.6.28
IPROUTE2_SOURCE:=iproute2-$(IPROUTE2_VERSION).tar.bz2
IPROUTE2_SITE:=http://developer.osdl.org/dev/iproute2/download/
IPROUTE2_DIR:=$(BUILD_DIR)/iproute2-$(IPROUTE2_VERSION)
IPROUTE2_CAT:=$(BZCAT)
IPROUTE2_BINARY:=tc/tc
IPROUTE2_TARGET_BINARY:=sbin/tc

$(DL_DIR)/$(IPROUTE2_SOURCE):
	$(call DOWNLOAD,$(IPROUTE2_SITE),$(IPROUTE2_SOURCE))

iproute2-source: $(DL_DIR)/$(IPROUTE2_SOURCE)

$(IPROUTE2_DIR)/.unpacked: $(DL_DIR)/$(IPROUTE2_SOURCE)
	$(IPROUTE2_CAT) $(DL_DIR)/$(IPROUTE2_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(IPROUTE2_DIR)/.configured: $(IPROUTE2_DIR)/.unpacked
	(cd $(IPROUTE2_DIR); \
		./configure; \
		$(SED) '/TC_CONFIG_ATM/s:=.*:=n:' Config; \
		$(SED) '/^CCOPTS/s:-O2.*:$(TARGET_CFLAGS):' Makefile)
	touch $@

$(IPROUTE2_DIR)/$(IPROUTE2_BINARY): $(IPROUTE2_DIR)/.configured
	$(MAKE) \
		-C $(IPROUTE2_DIR) \
		KERNEL_INCLUDE=$(LINUX_SOURCE_DIR)/include \
		CC=$(TARGET_CC) \
		AR=$(TARGET_CROSS)ar \
		NETEM_DIST="" \
		SUBDIRS="lib ip tc"

$(TARGET_DIR)/$(IPROUTE2_TARGET_BINARY): $(IPROUTE2_DIR)/$(IPROUTE2_BINARY)
	$(INSTALL) -m 0755 $(IPROUTE2_DIR)/ip/ip $(TARGET_DIR)/sbin/ip
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/sbin/ip
	$(INSTALL) -m 0755 $(IPROUTE2_DIR)/$(IPROUTE2_BINARY) $@
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

iproute2: $(TARGET_DIR)/$(IPROUTE2_TARGET_BINARY)

iproute2-clean:
	rm -f $(TARGET_DIR)/sbin/ip $(TARGET_DIR)/$(IPROUTE2_TARGET_BINARY)
	-$(MAKE) -C $(IPROUTE2_DIR) clean

iproute2-dirclean:
	rm -rf $(IPROUTE2_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_IPROUTE2),y)
TARGETS+=iproute2
endif
