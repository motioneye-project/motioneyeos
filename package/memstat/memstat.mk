#############################################################
#
# memstat
#
#############################################################

MEMSTAT_VERSION:=0.5
MEMSTAT_SOURCE:=memstat_$(MEMSTAT_VERSION).tar.gz
MEMSTAT_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/m/memstat
MEMSTAT_DIR:=$(BUILD_DIR)/memstat-$(MEMSTAT_VERSION)

$(DL_DIR)/$(MEMSTAT_SOURCE):
	$(WGET) -P $(DL_DIR) $(MEMSTAT_SITE)/$(MEMSTAT_SOURCE)

$(MEMSTAT_DIR)/.unpacked: $(DL_DIR)/$(MEMSTAT_SOURCE)
	$(ZCAT) $(DL_DIR)/$(MEMSTAT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MEMSTAT_DIR) package/memstat/ memstat-$(MEMSTAT_VERSION)\*.patch
	touch $@

$(MEMSTAT_DIR)/.configured: $(MEMSTAT_DIR)/.unpacked
	touch $@

$(MEMSTAT_DIR)/memstat: $(MEMSTAT_DIR)/.configured
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(@D)/memstat.c -o $@

$(TARGET_DIR)/usr/bin/memstat: $(MEMSTAT_DIR)/memstat
	[ -e $(TARGET_DIR)/etc/memstat.conf ] || \
		$(INSTALL) -m 0644 -D $(^D)/memstat.conf $(TARGET_DIR)/etc
	$(INSTALL) -m 0755 -D $^ $@
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

memstat: uclibc $(TARGET_DIR)/usr/bin/memstat

memstat-source: $(DL_DIR)/$(MEMSTAT_SOURCE)

memstat-clean:
	rm -f $(MEMSTAT_DIR)/memstat \
		$(TARGET_DIR)/etc/memstat.conf $(TARGET_DIR)/usr/bin/memstat

memstat-dirclean:
	rm -rf $(MEMSTAT_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MEMSTAT)),y)
TARGETS+=memstat
endif
