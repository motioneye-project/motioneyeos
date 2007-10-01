#############################################################
#
# libtool
#
#############################################################
LIBTOOL_VERSION:=1.5.24
LIBTOOL_SOURCE:=libtool-$(LIBTOOL_VERSION).tar.gz
LIBTOOL_SITE:=http://ftp.gnu.org/pub/gnu/libtool
LIBTOOL_CAT:=$(ZCAT)
LIBTOOL_SRC_DIR:=$(TOOL_BUILD_DIR)/libtool-$(LIBTOOL_VERSION)
LIBTOOL_DIR:=$(BUILD_DIR)/libtool-$(LIBTOOL_VERSION)
LIBTOOL_HOST_DIR:=$(TOOL_BUILD_DIR)/libtool-$(LIBTOOL_VERSION)-host
LIBTOOL_BINARY:=libtool
LIBTOOL_TARGET_BINARY:=usr/bin/libtool

$(DL_DIR)/$(LIBTOOL_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBTOOL_SITE)/$(LIBTOOL_SOURCE)

libtool-source: $(DL_DIR)/$(LIBTOOL_SOURCE)

$(LIBTOOL_SRC_DIR)/.unpacked: $(DL_DIR)/$(LIBTOOL_SOURCE)
	$(LIBTOOL_CAT) $(DL_DIR)/$(LIBTOOL_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

#############################################################
#
# libtool for the target
#
#############################################################

$(LIBTOOL_DIR)/.configured: $(LIBTOOL_SRC_DIR)/.unpacked
	mkdir -p $(LIBTOOL_DIR)
	(cd $(LIBTOOL_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		$(LIBTOOL_SRC_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
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
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		$(DISABLE_NLS) \
	)
	touch $@

$(LIBTOOL_DIR)/$(LIBTOOL_BINARY): $(LIBTOOL_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBTOOL_DIR)
	touch -c $@

$(TARGET_DIR)/$(LIBTOOL_TARGET_BINARY): $(LIBTOOL_DIR)/$(LIBTOOL_BINARY)
	$(MAKE) \
	    prefix=$(TARGET_DIR)/usr \
	    exec_prefix=$(TARGET_DIR)/usr \
	    bindir=$(TARGET_DIR)/usr/bin \
	    sbindir=$(TARGET_DIR)/usr/sbin \
	    libexecdir=$(TARGET_DIR)/usr/lib \
	    datadir=$(TARGET_DIR)/usr/share \
	    sysconfdir=$(TARGET_DIR)/etc \
	    localstatedir=$(TARGET_DIR)/var \
	    libdir=$(TARGET_DIR)/usr/lib \
	    infodir=$(TARGET_DIR)/usr/share/info \
	    mandir=$(TARGET_DIR)/usr/share/man \
	    includedir=$(TARGET_DIR)/usr/include \
	    -C $(LIBTOOL_DIR) install
	$(STRIPCMD) $(TARGET_DIR)//usr/lib/libltdl.so.*.*.* > /dev/null 2>&1
	$(SED) "s,^CC.*,CC=\"/usr/bin/gcc\"," $(TARGET_DIR)/usr/bin/libtool
	$(SED) "s,^LD.*,LD=\"/usr/bin/ld\"," $(TARGET_DIR)/usr/bin/libtool
	rm -rf $(TARGET_DIR)/share/locale
	rm -rf $(TARGET_DIR)/usr/share/doc
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/man
endif
	touch -c $@

libtool: uclibc $(TARGET_DIR)/$(LIBTOOL_TARGET_BINARY)

libtool-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(LIBTOOL_DIR) uninstall
	-$(MAKE) -C $(LIBTOOL_DIR) clean

libtool-cross: uclibc $(LIBTOOL_DIR)/$(LIBTOOL_BINARY)

libtool-cross-clean:
	-$(MAKE) -C $(LIBTOOL_DIR) clean

libtool-dirclean:
	rm -rf $(LIBTOOL_DIR)

#############################################################
#
# libtool for the host
#
#############################################################

$(LIBTOOL_HOST_DIR)/.configured: $(LIBTOOL_SRC_DIR)/.unpacked
	mkdir -p $(LIBTOOL_HOST_DIR)
	(cd $(LIBTOOL_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		$(LIBTOOL_SRC_DIR)/configure \
		--prefix=$(STAGING_DIR)/usr \
		$(DISABLE_NLS) \
	)
	touch $@

$(LIBTOOL_HOST_DIR)/$(LIBTOOL_BINARY): $(LIBTOOL_HOST_DIR)/.configured
	$(MAKE) -C $(LIBTOOL_HOST_DIR)
	touch -c $@

$(STAGING_DIR)/$(LIBTOOL_TARGET_BINARY): $(LIBTOOL_HOST_DIR)/$(LIBTOOL_BINARY)
	$(MAKE) -C $(LIBTOOL_HOST_DIR) install
	rm -rf $(STAGING_DIR)/share/locale
	rm -rf $(STAGING_DIR)/usr/share/doc
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(STAGING_DIR)/usr/share/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(STAGING_DIR)/usr/share/man
endif
	touch -c $@

host-libtool: $(STAGING_DIR)/$(LIBTOOL_TARGET_BINARY)

host-libtool-clean:
	$(MAKE) -C $(LIBTOOL_HOST_DIR) uninstall
	-$(MAKE) -C $(LIBTOOL_HOST_DIR) clean

host-libtool-dirclean:
	rm -rf $(LIBTOOL_HOST_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBTOOL)),y)
TARGETS+=libtool
endif
