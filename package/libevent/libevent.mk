#############################################################
#
# libevent
#
#############################################################
LIBEVENT_VERSION:=1.2
LIBEVENT_SOURCE:=libevent-$(LIBEVENT_VERSION).tar.gz
LIBEVENT_SITE:=http://monkey.org/~provos/
LIBEVENT_DIR:=$(BUILD_DIR)/libevent-$(LIBEVENT_VERSION)
LIBEVENT_CAT:=$(ZCAT)
LIBEVENT_BINARY:=libevent.la
LIBEVENT_TARGET_BINARY:=usr/lib/libevent.so

$(DL_DIR)/$(LIBEVENT_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBEVENT_SITE)/$(LIBEVENT_SOURCE)

libevent-source: $(DL_DIR)/$(LIBEVENT_SOURCE)

libevent-unpacked: $(LIBEVENT_DIR)/.unpacked
$(LIBEVENT_DIR)/.unpacked: $(DL_DIR)/$(LIBEVENT_SOURCE)
	$(LIBEVENT_CAT) $(DL_DIR)/$(LIBEVENT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBEVENT_DIR) package/libevent/ \*.patch
	touch $@

$(LIBEVENT_DIR)/.configured: $(LIBEVENT_DIR)/.unpacked
	(cd $(LIBEVENT_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--disable-static \
		--with-gnu-ld \
	)
	touch $@

$(LIBEVENT_DIR)/$(LIBEVENT_BINARY): $(LIBEVENT_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(LIBEVENT_DIR)

$(STAGING_DIR)/$(LIBEVENT_TARGET_BINARY): $(LIBEVENT_DIR)/$(LIBEVENT_BINARY)
	$(MAKE) -C $(LIBEVENT_DIR) DESTDIR=$(STAGING_DIR) install

$(TARGET_DIR)/$(LIBEVENT_TARGET_BINARY): $(STAGING_DIR)/$(LIBEVENT_TARGET_BINARY)
	$(MAKE) -C $(LIBEVENT_DIR) DESTDIR=$(TARGET_DIR) install
	rm -f $(addprefix $(TARGET_DIR)/usr/,lib/libevent*.la \
					     include/ev*)
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -fr $(TARGET_DIR)/usr/share/man
endif

libevent: uclibc $(TARGET_DIR)/$(LIBEVENT_TARGET_BINARY)

libevent-clean:
	rm -f $(TARGET_DIR)/$(LIBEVENT_TARGET_BINARY)*
	-$(MAKE) -C $(LIBEVENT_DIR) clean

libevent-dirclean:
	rm -rf $(LIBEVENT_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LIBEVENT),y)
TARGETS+=libevent
endif
