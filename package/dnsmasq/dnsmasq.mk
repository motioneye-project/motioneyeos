#############################################################
#
# dnsmasq
#
#############################################################

DNSMASQ_SITE:=http://thekelleys.org.uk/dnsmasq
DNSMASQ_UPVER:=2.40
DNSMASQ_SOURCE:=dnsmasq-$(DNSMASQ_UPVER).tar.gz
DNSMASQ_DIR:=$(BUILD_DIR)/dnsmasq-$(DNSMASQ_UPVER)
DNSMASQ_BINARY:=dnsmasq
DNSMASQ_TARGET_BINARY:=usr/sbin/dnsmasq

DNSMASQ_COPTS:=

ifneq ($(BR2_INET_IPV6),y)
DNSMASQ_COPTS+=-DNO_IPV6
endif

ifneq ($(BR2_PACKAGE_DNSMASQ_TFTP),y)
DNSMASQ_COPTS+=-DNO_TFTP
endif

$(DL_DIR)/$(DNSMASQ_SOURCE):
	$(WGET) -P $(DL_DIR) $(DNSMASQ_SITE)/$(DNSMASQ_SOURCE)

$(DNSMASQ_DIR)/.source: $(DL_DIR)/$(DNSMASQ_SOURCE)
	$(ZCAT) $(DL_DIR)/$(DNSMASQ_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(DNSMASQ_DIR) package/dnsmasq/ \*.patch
	touch $@

$(DNSMASQ_DIR)/src/$(DNSMASQ_BINARY): $(DNSMASQ_DIR)/.source
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" \
		COPTS='$(DNSMASQ_COPTS)' PREFIX=/usr -C $(DNSMASQ_DIR)

$(TARGET_DIR)/$(DNSMASQ_TARGET_BINARY): $(DNSMASQ_DIR)/src/$(DNSMASQ_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) PREFIX=/usr -C $(DNSMASQ_DIR) install
	$(STRIPCMD) $(TARGET_DIR)/$(DNSMASQ_TARGET_BINARY)
	mkdir -p $(TARGET_DIR)/var/lib/misc
	# Isn't this vulnerable to symlink attacks?
	ln -sf /tmp/dnsmasq.leases $(TARGET_DIR)/var/lib/misc/dnsmasq.leases
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/man
endif

dnsmasq: uclibc $(TARGET_DIR)/$(DNSMASQ_TARGET_BINARY)

dnsmasq-source: $(DL_DIR)/$(DNSMASQ_SOURCE)

dnsmasq-clean:
	rm -f $(addprefix $(TARGET_DIR)/,var/lib/misc/dnsmasq.leases \
					 usr/share/man/man?/dnsmasq.* \
					 $(DNSMASQ_TARGET_BINARY))
	-$(MAKE) -C $(DNSMASQ_DIR) clean

dnsmasq-dirclean:
	rm -rf $(DNSMASQ_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DNSMASQ)),y)
TARGETS+=dnsmasq
endif
