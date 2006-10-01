#############################################################
#
# ltrace
#
#############################################################
LTRACE_SOURCE=ltrace_0.3.36.orig.tar.gz
LTRACE_SOURCE2=ltrace_0.3.36-2.diff.gz
LTRACE_SITE=http://ftp.debian.org/debian/pool/main/l/ltrace
LTRACE_DIR=$(BUILD_DIR)/ltrace-0.3.36
LTRACE_BINARY=ltrace
LTRACE_TARGET_BINARY=usr/bin/ltrace

LTRACE_ARCH:=$(ARCH)
ifeq ("$(strip $(ARCH))","armeb")
LTRACE_ARCH:=arm
endif

$(DL_DIR)/$(LTRACE_SOURCE):
	$(WGET) -P $(DL_DIR) $(LTRACE_SITE)/$(LTRACE_SOURCE)

$(DL_DIR)/$(LTRACE_SOURCE2):
	$(WGET) -P $(DL_DIR) $(LTRACE_SITE)/$(LTRACE_SOURCE2)

$(LTRACE_DIR)/.source: $(DL_DIR)/$(LTRACE_SOURCE) $(DL_DIR)/$(LTRACE_SOURCE2)
	$(ZCAT) $(DL_DIR)/$(LTRACE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(ZCAT) $(DL_DIR)/$(LTRACE_SOURCE2) | patch -p1 -d $(LTRACE_DIR)
	touch $(LTRACE_DIR)/.source

$(LTRACE_DIR)/.configured: $(LTRACE_DIR)/.source
	(cd $(LTRACE_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
	);
	touch $(LTRACE_DIR)/.configured;

$(LTRACE_DIR)/$(LTRACE_BINARY): $(LTRACE_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) LD=$(TARGET_CROSS)ld ARCH=$(LTRACE_ARCH) \
		-C $(LTRACE_DIR)

$(TARGET_DIR)/$(LTRACE_TARGET_BINARY): $(LTRACE_DIR)/$(LTRACE_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) ARCH=$(LTRACE_ARCH) \
		-C $(LTRACE_DIR) install
	rm -Rf $(TARGET_DIR)/usr/man

ltrace: uclibc libelf $(TARGET_DIR)/$(LTRACE_TARGET_BINARY)

ltrace-source: $(DL_DIR)/$(LTRACE_SOURCE)

ltrace-clean:
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(LTRACE_DIR) uninstall
	-$(MAKE) -C $(LTRACE_DIR) clean

ltrace-dirclean:
	rm -rf $(LTRACE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LTRACE)),y)
TARGETS+=ltrace
endif
