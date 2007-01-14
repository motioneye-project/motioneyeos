#############################################################
#
# ruby
#
#############################################################
RUBY_SOURCE:=ruby-1.8.2.tar.gz
RUBY_SITE:=ftp://ftp.ruby-lang.org/pub/ruby/1.8
RUBY_DIR:=$(BUILD_DIR)/ruby-1.8.2
RUBY_CAT:=$(ZCAT)
RUBY_BINARY:=ruby
RUBY_TARGET_BINARY:=usr/bin/ruby

$(DL_DIR)/$(RUBY_SOURCE):
	 $(WGET) -P $(DL_DIR) $(RUBY_SITE)/$(RUBY_SOURCE)

ruby-source: $(DL_DIR)/$(RUBY_SOURCE)

$(RUBY_DIR)/.unpacked: $(DL_DIR)/$(RUBY_SOURCE)
	$(RUBY_CAT) $(DL_DIR)/$(RUBY_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(RUBY_DIR) package/ruby/ ruby-*.patch
	(cd $(RUBY_DIR); autoreconf);
	touch $(RUBY_DIR)/.unpacked

$(RUBY_DIR)/.configured: $(RUBY_DIR)/.unpacked
	(cd $(RUBY_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
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
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	);
	touch $(RUBY_DIR)/.configured

$(RUBY_DIR)/$(RUBY_BINARY): $(RUBY_DIR)/.configured
	$(MAKE) -C $(RUBY_DIR)

$(TARGET_DIR)/$(RUBY_TARGET_BINARY): $(RUBY_DIR)/$(RUBY_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(RUBY_DIR) install
	rm -rf $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

ruby: uclibc $(TARGET_DIR)/$(RUBY_TARGET_BINARY)

ruby-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(RUBY_DIR) uninstall
	-$(MAKE) -C $(RUBY_DIR) clean

ruby-dirclean:
	rm -rf $(RUBY_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_RUBY)),y)
TARGETS+=ruby
endif
