#############################################################
#
# pppd
#
#############################################################

PPPD_VERSION = 2.4.5
PPPD_SOURCE = ppp-$(PPPD_VERSION).tar.gz
PPPD_SITE = ftp://ftp.samba.org/pub/ppp
PPPD_TARGET_BINS = chat pppd pppdump pppstats
PPPD_MANPAGES = $(if $(BR2_HAVE_DOCUMENTATION),chat pppd pppdump pppstats)
PPPD_MAKE = $(MAKE) CC="$(TARGET_CC)" COPTS="$(TARGET_CFLAGS)" -C $(PPPD_DIR) $(PPPD_MAKE_OPT)

ifeq ($(BR2_PACKAGE_PPPD_FILTER),y)
	PPPD_DEPENDENCIES += libpcap
	PPPD_MAKE_OPT += FILTER=y
endif

ifeq ($(BR2_INET_IPV6),y)
	PPPD_MAKE_OPT += HAVE_INET6=y
endif

$(eval $(call AUTOTARGETS,package,pppd))

$(PPPD_HOOK_POST_EXTRACT):
	$(SED) 's/FILTER=y/#FILTER=y/' $(PPPD_DIR)/pppd/Makefile.linux
	$(SED) 's/ifneq ($$(wildcard \/usr\/include\/pcap-bpf.h),)/ifdef FILTER/' $(PPPD_DIR)/*/Makefile.linux
	touch $@

$(PPPD_TARGET_INSTALL_TARGET):
	$(call MESSAGE,"Installing to target")
	for sbin in $(PPPD_TARGET_BINS); do \
		$(INSTALL) -D $(PPPD_DIR)/$$sbin/$$sbin \
			$(TARGET_DIR)/usr/sbin/$$sbin; \
	done
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/minconn.so \
		$(TARGET_DIR)/usr/lib/pppd/$(PPPD_VERSION)/minconn.so
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/passprompt.so \
		$(TARGET_DIR)/usr/lib/pppd/$(PPPD_VERSION)/passprompt.so
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/passwordfd.so \
		$(TARGET_DIR)/usr/lib/pppd/$(PPPD_VERSION)/passwordfd.so
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/pppoatm/pppoatm.so \
		$(TARGET_DIR)/usr/lib/pppd/$(PPPD_VERSION)/pppoatm.so
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/rp-pppoe/rp-pppoe.so \
		$(TARGET_DIR)/usr/lib/pppd/$(PPPD_VERSION)/rp-pppoe.so
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/rp-pppoe/pppoe-discovery \
		$(TARGET_DIR)/usr/sbin/pppoe-discovery
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/winbind.so \
		$(TARGET_DIR)/usr/lib/pppd/$(PPPD_VERSION)/winbind.so
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/pppol2tp/openl2tp.so \
		$(TARGET_DIR)/usr/lib/pppd/$(PPPD_VERSION)/openl2tp.so
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/pppol2tp/pppol2tp.so \
		$(TARGET_DIR)/usr/lib/pppd/$(PPPD_VERSION)/pppol2tp.so
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/radius/radattr.so \
		$(TARGET_DIR)/usr/lib/pppd/$(PPPD_VERSION)/radattr.so
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/radius/radius.so \
		$(TARGET_DIR)/usr/lib/pppd/$(PPPD_VERSION)/radius.so
	$(INSTALL) -D $(PPPD_DIR)/pppd/plugins/radius/radrealms.so \
		$(TARGET_DIR)/usr/lib/pppd/$(PPPD_VERSION)/radrealms.so
	for m in $(PPPD_MANPAGES); do \
		$(INSTALL) -m 644 -D $(PPPD_DIR)/$$m/$$m.8 \
			$(TARGET_DIR)/usr/share/man/man8/$$m.8; \
	done
	touch $@

$(PPPD_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/, $(PPPD_TARGET_BINS))
	rm -f $(TARGET_DIR)/usr/sbin/pppoe-discovery
	for m in $(PPPD_MANPAGES); do \
		rm -f $(TARGET_DIR)/usr/share/man/man8/$$m.8; \
	done
	rm -rf $(TARGET_DIR)/usr/lib/pppd
	rm -f $(PPPD_TARGET_INSTALL_TARGET) $(PPPD_HOOK_POST_INSTALL)
