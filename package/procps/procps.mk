#############################################################
#
# procps
#
#############################################################
PROCPS_VER=3.2.3
PROCPS_SOURCE=procps-$(PROCPS_VER).tar.gz
PROCPS_SITE=http://procps.sourceforge.net/
PROCPS_DIR=$(BUILD_DIR)/procps-$(PROCPS_VER)
PROCPS_BINARY=ps/ps
PROCPS_TARGET_BINARY=usr/bin/vmstat

$(DL_DIR)/$(PROCPS_SOURCE):
	$(WGET) -P $(DL_DIR) $(PROCPS_SITE)/$(PROCPS_SOURCE)

$(PROCPS_DIR)/.source: $(DL_DIR)/$(PROCPS_SOURCE)
	zcat $(DL_DIR)/$(PROCPS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(PROCPS_DIR) package/procps/ procps*.patch
	$(SED) '/^CFLAGS/s:-O2:$(TARGET_CFLAGS):' $(PROCPS_DIR)/Makefile
	touch $(PROCPS_DIR)/.source

$(PROCPS_DIR)/$(PROCPS_BINARY): $(PROCPS_DIR)/.source
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(PROCPS_DIR)

$(TARGET_DIR)/$(PROCPS_TARGET_BINARY): $(PROCPS_DIR)/$(PROCPS_BINARY)
	$(TARGET_CONFIGURE_OPTS) $(MAKE) DESTDIR=$(TARGET_DIR) \
		install='install -D' -C $(PROCPS_DIR) lib64=/lib \
		ldconfig='/bin/true' install
	rm -Rf $(TARGET_DIR)/usr/man

procps: uclibc ncurses $(TARGET_DIR)/$(PROCPS_TARGET_BINARY)

procps-source: $(DL_DIR)/$(PROCPS_SOURCE)

procps-clean:
	for bin in uptime tload free w \
	           top vmstat watch skill \
	           snice kill sysctl pmap \
	           pgrep pkill slabtop ; do \
		rm -f $(TARGET_DIR)/usr/bin/$${bin} ; \
	done
	rm -f $(TARGET_DIR)/lib/libproc*

procps-dirclean:
	rm -rf $(PROCPS_DIR)

