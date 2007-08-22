#############################################################
#
# ltt
#
#############################################################
LTT_VERSION:=0.9.5a
LTT_SOURCE:=TraceToolkit-$(LTT_VERSION).tgz
LTT_SITE:=http://www.opersys.com/ftp/pub/LTT
LTT_CAT:=$(ZCAT)
LTT_DIR1:=$(TOOL_BUILD_DIR)/TraceToolkit-$(LTT_VERSION:a=)
LTT_DIR2:=$(BUILD_DIR)/TraceToolkit-$(LTT_VERSION:a=)
LTT_BINARY:=Visualizer/tracevisualizer
LTT_TARGET_BINARY:=Daemon/tracedaemon

$(DL_DIR)/$(LTT_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LTT_SITE)/$(LTT_SOURCE)

ltt-source: $(DL_DIR)/$(LTT_SOURCE)


#############################################################
#
# build tracevisualizer for use on the host system
#
#############################################################
$(LTT_DIR1)/.unpacked: $(DL_DIR)/$(LTT_SOURCE)
	$(LTT_CAT) $(DL_DIR)/$(LTT_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LTT_DIR1) package/ltt ltt\*.patch
	touch $(LTT_DIR1)/.unpacked

# Build without GTK if not available
LTT_WITHOUT_GTK:=$(shell which gtk-config > /dev/null 2>&1 || echo "--without-gtk")

$(LTT_DIR1)/.configured: $(LTT_DIR1)/.unpacked
	(cd $(LTT_DIR1); rm -rf config.cache; \
		./configure \
		--prefix=$(TOOL_BUILD_DIR) \
		$(LTT_WITHOUT_GTK) \
	)
	touch $(LTT_DIR1)/.configured

$(LTT_DIR1)/$(LTT_BINARY): $(LTT_DIR1)/.configured
	$(MAKE) -C $(LTT_DIR1)/LibLTT
	$(MAKE) -C $(LTT_DIR1)/Visualizer

$(TOOL_BUILD_DIR)/bin/tracevisualizer: $(LTT_DIR1)/$(LTT_BINARY)
	$(MAKE) -C $(LTT_DIR1)/LibLTT install
	$(MAKE) -C $(LTT_DIR1)/Visualizer install

host-ltt-tracevisualizer: $(TOOL_BUILD_DIR)/bin/tracevisualizer

host-ltt-clean:
	$(MAKE) -C $(LTT_DIR1) clean

host-ltt-dirclean:
	rm -rf $(LTT_DIR1)


#############################################################
#
# build tracedaemon for use on the target system
#
#############################################################
$(LTT_DIR2)/.unpacked: $(DL_DIR)/$(LTT_SOURCE)
	$(LTT_CAT) $(DL_DIR)/$(LTT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LTT_DIR2) package/ltt ltt\*.patch
	touch $(LTT_DIR2)/.unpacked

$(LTT_DIR2)/.configured: $(LTT_DIR2)/.unpacked
	(cd $(LTT_DIR2); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
	)
	touch $(LTT_DIR2)/.configured

$(LTT_DIR2)/$(LTT_TARGET_BINARY): $(LTT_DIR2)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LTT_DIR2)/LibUserTrace
	$(MAKE) CC=$(TARGET_CC) -C $(LTT_DIR2)/Daemon

$(TARGET_DIR)/usr/bin/tracedaemon: $(LTT_DIR2)/$(LTT_TARGET_BINARY)
	$(MAKE) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) \
		-C $(LTT_DIR2)/LibUserTrace install
	$(MAKE) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) \
		-C $(LTT_DIR2)/Daemon install
	$(STRIP) $(TARGET_DIR)/usr/bin/tracedaemon > /dev/null 2>&1
	$(INSTALL) -D -m 0755 package/ltt/S27tracer $(TARGET_DIR)/etc/init.d

ltt-tracedaemon: uclibc $(TARGET_DIR)/usr/bin/tracedaemon

ltt-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(LTT_DIR2) uninstall
	-$(MAKE) -C $(LTT_DIR2) clean

ltt-dirclean:
	rm -rf $(LTT_DIR2)


ltt: host-ltt-tracevisualizer ltt-tracedaemon

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LTT)),y)
TARGETS+=ltt
endif
