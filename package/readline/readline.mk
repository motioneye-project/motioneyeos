#############################################################
#
# build GNU readline
#
#############################################################
READLINE_VER:=5.0
READLINE_SITE:=ftp://ftp.cwru.edu/pub/bash
READLINE_SOURCE:=readline-$(READLINE_VER).tar.gz
READLINE_DIR:=$(BUILD_DIR)/readline-$(READLINE_VER)
READLINE_CAT:=zcat
READLINE_BINARY:=libhistory.so.$(READLINE_VER)
READLINE_TARGET_BINARY:=$(TARGET_DIR)/lib/$(READLINE_BINARY)



$(DL_DIR)/$(READLINE_SOURCE):
	$(WGET) -P $(DL_DIR) $(READLINE_SITE)/$(READLINE_SOURCE)

$(READLINE_DIR)/.unpacked: $(DL_DIR)/$(READLINE_SOURCE)
	mkdir -p $(READLINE_DIR)
	tar  -C $(BUILD_DIR) -zxvf $(DL_DIR)/$(READLINE_SOURCE)
	# patch to fix old autoconf
	patch -d $(READLINE_DIR) -p1 -u  < $(BASE_DIR)/package/readline/readline5.patch
	touch $(READLINE_DIR)/.unpacked

$(READLINE_DIR)/.configured: $(READLINE_DIR)/.unpacked
	mkdir -p $(READLINE_DIR)
	(cd $(READLINE_DIR); rm -rf config.cache; \
		$(READLINE_DIR)/configure \
                --target=$(GNU_TARGET_NAME) \
                --host=$(GNU_TARGET_NAME) \
                --build=$(GNU_HOST_NAME)  \
                --prefix=$(STAGING_DIR)  \
	);
	touch $(READLINE_DIR)/.configured


$(READLINE_DIR)/$(READLINE_BINARY): $(READLINE_DIR)/.configured
	$(MAKE)  -C $(READLINE_DIR)

$(STAGING_DIR)/$(READLINE_TARGET_BINARY): $(READLINE_DIR)/.configured
	$(MAKE) -C $(READLINE_DIR)  install

# Install to Staging area
readline: $(READLINE_DIR)/.configured
	BUILD_CC=$(TARGET_CC) HOSTCC=$(HOSTCC) CC=$(TARGET_CC) \
        $(MAKE1) \
            prefix=$(STAGING_DIR) \
            exec_prefix=$(STAGING_DIR) \
            bindir=$(STAGING_DIR)/bin \
            sbindir=$(STAGING_DIR)/sbin \
            libexecdir=$(STAGING_DIR)/lib \
            datadir=$(STAGING_DIR)/usr/share \
            sysconfdir=$(STAGING_DIR)/etc \
            localstatedir=$(STAGING_DIR)/var \
            libdir=$(STAGING_DIR)/lib \
            infodir=$(STAGING_DIR)/info \
            mandir=$(STAGING_DIR)/man \
            includedir=$(STAGING_DIR)/include \
            -C $(READLINE_DIR) install;

# Install only run-time to Target directory
readline-target: $(READLINE_DIR)/.configured
	BUILD_CC=$(TARGET_CC) HOSTCC=$(HOSTCC) CC=$(TARGET_CC) \
	$(MAKE1) \
            prefix=$(TARGET_DIR) \
            libdir=$(TARGET_DIR)/lib \
	-C $(READLINE_DIR) install-shared

readline-clean:
	$(MAKE) -C $(READLINE_DIR) uninstall
	-$(MAKE) -C $(READLINE_DIR) clean

readline-dirclean:
	rm -rf $(READLINE_DIR)

readline-source:  $(DL_DIR)/$(READLINE_SOURCE)   $(READLINE_DIR)/.unpacked

ifeq ($(strip $(BR2_READLINE)),y)
TARGETS+=readline
endif
ifeq ($(strip $(BR2_PACKAGE_READLINE_TARGET)),y)
TARGETS+=readline_target
endif
