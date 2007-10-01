#############################################################
#
# iptables
#
#############################################################
IPTABLES_VERSION:=1.3.8
IPTABLES_SOURCE_URL:=http://ftp.netfilter.org/pub/iptables
IPTABLES_SOURCE:=iptables-$(IPTABLES_VERSION).tar.bz2
IPTABLES_CAT:=$(BZCAT)
IPTABLES_BUILD_DIR:=$(BUILD_DIR)/iptables-$(IPTABLES_VERSION)

$(DL_DIR)/$(IPTABLES_SOURCE):
	 $(WGET) -P $(DL_DIR) $(IPTABLES_SOURCE_URL)/$(IPTABLES_SOURCE)

$(IPTABLES_BUILD_DIR)/.unpacked: $(DL_DIR)/$(IPTABLES_SOURCE)
	$(IPTABLES_CAT) $(DL_DIR)/$(IPTABLES_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(IPTABLES_BUILD_DIR)/.configured: $(IPTABLES_BUILD_DIR)/.unpacked
	# Allow patches. Needed for openwrt for instance.
	toolchain/patch-kernel.sh $(IPTABLES_BUILD_DIR) package/iptables/ iptables\*.patch
	#
	$(SED) "s;\[ -f /usr/include/netinet/ip6.h \];grep -q '__UCLIBC_HAS_IPV6__ 1' \
		$(STAGING_DIR)/usr/include/bits/uClibc_config.h;" $(IPTABLES_BUILD_DIR)/Makefile
	touch $@

$(IPTABLES_BUILD_DIR)/iptables: $(IPTABLES_BUILD_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(IPTABLES_BUILD_DIR) \
		KERNEL_DIR=$(LINUX_HEADERS_DIR) \
		COPT_FLAGS="$(TARGET_CFLAGS)" \
		PREFIX=/usr \
		INCDIR="\$$(PREFIX)/include" \
		MANDIR="\$$(PREFIX)/share/man"

$(TARGET_DIR)/usr/sbin/iptables: $(IPTABLES_BUILD_DIR)/iptables
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(IPTABLES_BUILD_DIR) \
		KERNEL_DIR=$(LINUX_HEADERS_DIR) \
		COPT_FLAGS="$(TARGET_CFLAGS)" \
		PREFIX=/usr \
		INCDIR="\$$(PREFIX)/include" \
		MANDIR="\$$(PREFIX)/share/man" \
		DESTDIR=$(TARGET_DIR) install
	$(STRIPCMD) $(TARGET_DIR)/usr/sbin/iptables*
	$(STRIPCMD) $(TARGET_DIR)/usr/lib/iptables/*.so
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/man
endif

iptables: $(TARGET_DIR)/usr/sbin/iptables

iptables-source: $(DL_DIR)/$(IPTABLES_SOURCE)

iptables-clean:
	-$(MAKE1) -C $(IPTABLES_BUILD_DIR) clean
	rm -rf $(TARGET_DIR)/usr/sbin/iptables* $(TARGET_DIR)/usr/lib/iptables

iptables-dirclean:
	rm -rf $(IPTABLES_BUILD_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_IPTABLES)),y)
TARGETS+=iptables
endif
