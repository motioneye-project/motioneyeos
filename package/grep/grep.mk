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
		--prefix=/ \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--disable-perl-regexp \
		--without-included-regex \
	)
	touch $@

$(GNUGREP_DIR)/$(GNUGREP_BINARY): $(GNUGREP_DIR)/.configured
	$(MAKE) -C $(GNUGREP_DIR)

$(TARGET_DIR)/$(GNUGREP_TARGET_BINARY): $(GNUGREP_DIR)/$(GNUGREP_BINARY)
	for i in egrep fgrep grep; do \
		$(INSTALL) $(GNUGREP_DIR)/src/$$i $(@D); \
	done
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

grep: uclibc $(if $(BR2_ENABLE_LOCALE),gettext libintl) \
	 $(TARGET_DIR)/$(GNUGREP_TARGET_BINARY)
	echo deps: $^
grep-clean:
	rm -f $(addprefix $(TARGET_DIR)/bin/,egrep fgrep grep)
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
