#############################################################
#
# iproute2
#
#############################################################
IPROUTE2_VER:=2.6.9
IPROUTE2_STAMP:=ss040831
IPROUTE2_SOURCE:=iproute2-$(IPROUTE2_VER)-$(IPROUTE2_STAMP).tar.gz
IPROUTE2_SITE:=http://developer.osdl.org/dev/iproute2/download/
IPROUTE2_DIR:=$(BUILD_DIR)/iproute2-$(IPROUTE2_VER)
IPROUTE2_CAT:=zcat
IPROUTE2_BINARY:=tc/tc
IPROUTE2_TARGET_BINARY:=sbin/tc

$(DL_DIR)/$(IPROUTE2_SOURCE):
	$(WGET) -P $(DL_DIR) $(IPROUTE2_SITE)$(IPROUTE2_SOURCE)

$(IPROUTE2_DIR)/.unpacked: $(DL_DIR)/$(IPROUTE2_SOURCE)
	$(IPROUTE2_CAT) $(DL_DIR)/$(IPROUTE2_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(IPROUTE2_DIR)/.unpacked

$(IPROUTE2_DIR)/.configured: $(IPROUTE2_DIR)/.unpacked
	(cd $(IPROUTE2_DIR); \
		./configure; \
		$(SED) '/TC_CONFIG_ATM/s:=.*:=n:' Config; \
		$(SED) '/^CCOPTS/s:-O2.*:$(TARGET_CFLAGS):' Makefile)
	touch  $(IPROUTE2_DIR)/.configured

$(IPROUTE2_DIR)/$(IPROUTE2_BINARY): $(IPROUTE2_DIR)/.configured
	$(MAKE) \
		-C $(IPROUTE2_DIR) \
		KERNEL_INCLUDE=$(LINUX_SOURCE_DIR)/include \
		CC=$(TARGET_CC) \
		AR=$(TARGET_CROSS)ar \
		NETEM_DIST="" \
		SUBDIRS="lib tc"

$(TARGET_DIR)/$(IPROUTE2_TARGET_BINARY): $(IPROUTE2_DIR)/$(IPROUTE2_BINARY)
	install -Dc $(IPROUTE2_DIR)/$(IPROUTE2_BINARY) $(TARGET_DIR)/$(IPROUTE2_TARGET_BINARY)

iproute2: $(TARGET_DIR)/$(IPROUTE2_TARGET_BINARY)

iproute2-clean:
	rm -f $(TARGET_DIR)/$(IPROUTE2_TARGET_BINARY)
	-$(MAKE) -C $(IPROUTE2_DIR) clean

iproute2-dirclean:
	rm -rf $(IPROUTE2_DIR)
