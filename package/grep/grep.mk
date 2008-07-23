#############################################################
#
# grep
#
#############################################################
GNUGREP_VERSION:=2.5.1
GNUGREP_SOURCE:=grep_$(GNUGREP_VERSION).ds1.orig.tar.gz
GNUGREP_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/g/grep/
GNUGREP_DIR:=$(BUILD_DIR)/grep-$(GNUGREP_VERSION)
GNUGREP_CAT:=$(ZCAT)
GNUGREP_BINARY:=src/grep
GNUGREP_TARGET_BINARY:=bin/grep

ifeq ($(BR2_ENABLE_LOCALE),y)
GNUGREP_EXTRA_DEPS:=gettext libintl
endif

$(DL_DIR)/$(GNUGREP_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GNUGREP_SITE)/$(GNUGREP_SOURCE)

grep-source: $(DL_DIR)/$(GNUGREP_SOURCE)

$(GNUGREP_DIR)/.unpacked: $(DL_DIR)/$(GNUGREP_SOURCE)
	rm -rf $(GNUGREP_DIR).xxx
	$(GNUGREP_CAT) $(DL_DIR)/$(GNUGREP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	mv $(GNUGREP_DIR) $(GNUGREP_DIR).xxx
	$(GNUGREP_CAT) $(GNUGREP_DIR).xxx/grep_$(GNUGREP_VERSION).tar.gz | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	rm -rf $(GNUGREP_DIR).xxx
	$(CONFIG_UPDATE) $(GNUGREP_DIR)
	touch $@

$(GNUGREP_DIR)/.configured: $(GNUGREP_DIR)/.unpacked
	(cd $(GNUGREP_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
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
		--disable-perl-regexp \
		--without-included-regex \
	)
	touch $@

$(GNUGREP_DIR)/$(GNUGREP_BINARY): $(GNUGREP_DIR)/.configured
	$(MAKE) -C $(GNUGREP_DIR)

# This stuff is needed to work around GNU make deficiencies
grep-target_binary: $(GNUGREP_DIR)/$(GNUGREP_BINARY)
	@if [ -L $(TARGET_DIR)/$(GNUGREP_TARGET_BINARY) ]; then \
		rm -f $(TARGET_DIR)/$(GNUGREP_TARGET_BINARY); fi
	@if [ ! -f $(GNUGREP_DIR)/$(GNUGREP_BINARY) -o $(TARGET_DIR)/$(GNUGREP_TARGET_BINARY) -ot \
	$(GNUGREP_DIR)/$(GNUGREP_BINARY) ]; then \
	    set -x; \
	    rm -f $(TARGET_DIR)/bin/grep $(TARGET_DIR)/bin/egrep $(TARGET_DIR)/bin/fgrep; \
	    cp -a $(GNUGREP_DIR)/src/grep $(GNUGREP_DIR)/src/egrep \
		$(GNUGREP_DIR)/src/fgrep $(TARGET_DIR)/bin/; fi

grep: uclibc $(GNUGREP_EXTRA_DEPS) grep-target_binary

grep-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(GNUGREP_DIR) uninstall
	-$(MAKE) -C $(GNUGREP_DIR) clean

grep-dirclean:
	rm -rf $(GNUGREP_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_GREP)),y)
TARGETS+=grep
endif
