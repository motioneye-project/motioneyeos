#############################################################
#
# build ccache to make recompiles faster on the build system
#
#############################################################
CCACHE_SITE:=http://ccache.samba.org/ftp/ccache
CCACHE_SOURCE:=ccache-2.3.tar.gz
CCACHE_DIR:=$(TOOL_BUILD_DIR)/ccache-2.3
CCACHE_DIR2:=$(BUILD_DIR)/ccache-2.3
CCACHE_CAT:=zcat
CCACHE_BINARY:=ccache
CCACHE_TARGET_BINARY:=usr/bin/ccache

CCACHE_DIR1:=$(TOOL_BUILD_DIR)/ccache-build
$(DL_DIR)/$(CCACHE_SOURCE):
	$(WGET) -P $(DL_DIR) $(CCACHE_SITE)/$(CCACHE_SOURCE)

$(CCACHE_DIR)/.unpacked: $(DL_DIR)/$(CCACHE_SOURCE)
	$(CCACHE_CAT) $(DL_DIR)/$(CCACHE_SOURCE) | tar -C $(TOOL_BUILD_DIR) -xvf -
	touch $(CCACHE_DIR)/.unpacked

$(CCACHE_DIR)/.patched: $(CCACHE_DIR)/.unpacked
	touch $(CCACHE_DIR)/.patched

$(CCACHE_DIR2)/.configured: $(CCACHE_DIR)/.patched
	mkdir -p $(CCACHE_DIR2)
	(cd $(CCACHE_DIR2); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(CCACHE_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_NLS) \
	);
	touch $(CCACHE_DIR2)/.configured

$(CCACHE_DIR2)/$(CCACHE_BINARY): $(CCACHE_DIR2)/.configured
	$(MAKE) -C $(CCACHE_DIR2)

$(TARGET_DIR)/$(CCACHE_TARGET_BINARY): $(CCACHE_DIR2)/$(CCACHE_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(CCACHE_DIR2) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	# put a bunch of symlinks into /bin, since that is earlier
	# in the default PATH than /usr/bin where gcc lives
	(cd $(TARGET_DIR)/bin; \
		ln -fs /usr/bin/ccache cc; \
		ln -fs /usr/bin/ccache gcc; \
		ln -fs /usr/bin/ccache c++; \
		ln -fs /usr/bin/ccache g++;)

ccache_target: uclibc $(TARGET_DIR)/$(CCACHE_TARGET_BINARY)

ccache_target-sources: $(DL_DIR)/$(CCACHE_SOURCE)

ccache_target-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(CCACHE_DIR2) uninstall
	-$(MAKE) -C $(CCACHE_DIR2) clean

ccache_target-dirclean:
	rm -rf $(CCACHE_DIR2)

