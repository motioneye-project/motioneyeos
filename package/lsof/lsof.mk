#############################################################
#
# lsof
#
#############################################################
LSOF_VERSION:=4.80
LSOF_SOURCE:=lsof_$(LSOF_VERSION).tar.bz2
LSOF_SITE:=ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/
LSOF_CAT:=$(BZCAT)
LSOF_DIR:=$(BUILD_DIR)/lsof_$(LSOF_VERSION)
LSOF_BINARY:=lsof
LSOF_TARGET_BINARY:=bin/lsof
LSOF_INCLUDE:=$(STAGING_DIR)/usr/include

BR2_LSOF_CFLAGS:=
ifeq ($(BR2_LARGEFILE),)
BR2_LSOF_CFLAGS+=-U_FILE_OFFSET_BITS
endif
ifeq ($(BR2_INET_IPV6),)
BR2_LSOF_CFLAGS+=-UHASIPv6
endif

$(DL_DIR)/$(LSOF_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LSOF_SITE)/$(LSOF_SOURCE)

lsof-source: $(DL_DIR)/$(LSOF_SOURCE)

lsof-unpacked: $(LSOF_DIR)/.unpacked

$(LSOF_DIR)/.unpacked: $(DL_DIR)/$(LSOF_SOURCE)
	$(LSOF_CAT) $(DL_DIR)/$(LSOF_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	(cd $(LSOF_DIR);tar xf lsof_$(LSOF_VERSION)_src.tar;rm -f lsof_$(LSOF_VERSION)_src.tar)
	toolchain/patch-kernel.sh $(LSOF_DIR) package/lsof/ \*.patch
	touch $(LSOF_DIR)/.unpacked

$(LSOF_DIR)/.configured: $(LSOF_DIR)/.unpacked
	(cd $(LSOF_DIR)/lsof_$(LSOF_VERSION)_src; echo n | $(TARGET_CONFIGURE_OPTS) DEBUG="$(TARGET_CFLAGS) $(BR2_LSOF_CFLAGS)" LSOF_INCLUDE="$(LSOF_INCLUDE)" ./Configure linux)
	touch $(LSOF_DIR)/.configured

$(LSOF_DIR)/lsof_$(LSOF_VERSION)_src/$(LSOF_BINARY): $(LSOF_DIR)/.configured
ifeq ($(UCLIBC_HAS_WCHAR),)
	$(SED) 's,^#define[[:space:]]*HASWIDECHAR.*,#undef HASWIDECHAR,' $(LSOF_DIR)/lsof_$(LSOF_VERSION)_src/machine.h
	$(SED) 's,^#define[[:space:]]*WIDECHARINCL.*,,' $(LSOF_DIR)/lsof_$(LSOF_VERSION)_src/machine.h
endif
ifeq ($(UCLIBC_HAS_LOCALE),)
	$(SED) 's,^#define[[:space:]]*HASSETLOCALE.*,#undef HASSETLOCALE,' $(LSOF_DIR)/lsof_$(LSOF_VERSION)_src/machine.h
endif
	$(MAKE) $(TARGET_CONFIGURE_OPTS) DEBUG="$(TARGET_CFLAGS) $(BR2_LSOF_CFLAGS)" -C $(LSOF_DIR)/lsof_$(LSOF_VERSION)_src

$(TARGET_DIR)/$(LSOF_TARGET_BINARY): $(LSOF_DIR)/lsof_$(LSOF_VERSION)_src/$(LSOF_BINARY)
	cp $(LSOF_DIR)/lsof_$(LSOF_VERSION)_src/$(LSOF_BINARY) $@
	$(STRIPCMD) $@

lsof: uclibc $(TARGET_DIR)/$(LSOF_TARGET_BINARY)

lsof-clean:
	-rm -f $(TARGET_DIR)/$(LSOF_TARGET_BINARY)
	-$(MAKE) -C $(LSOF_DIR)/lsof_$(LSOF_VERSION)_src clean

lsof-dirclean:
	rm -rf $(LSOF_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LSOF)),y)
TARGETS+=lsof
endif
