#############################################################
#
# build GNU readline
#
#############################################################
READLINE_VER:=5.1
READLINE_SITE:=ftp://ftp.cwru.edu/pub/bash
READLINE_SOURCE:=readline-$(READLINE_VER).tar.gz
READLINE_DIR:=$(BUILD_DIR)/readline-$(READLINE_VER)
READLINE_CAT:=$(ZCAT)
READLINE_BINARY:=libhistory.a
READLINE_TARGET_BINARY:=lib/$(READLINE_BINARY)

$(DL_DIR)/$(READLINE_SOURCE):
	$(WGET) -P $(DL_DIR) $(READLINE_SITE)/$(READLINE_SOURCE)

$(READLINE_DIR)/.unpacked: $(DL_DIR)/$(READLINE_SOURCE)
	mkdir -p $(READLINE_DIR)
	tar -C $(BUILD_DIR) -zxf $(DL_DIR)/$(READLINE_SOURCE)
	$(CONFIG_UPDATE) $(READLINE_DIR)
	touch $(READLINE_DIR)/.unpacked

$(READLINE_DIR)/.configured: $(READLINE_DIR)/.unpacked
	(cd $(READLINE_DIR); rm -rf config.cache; \
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
		--includedir=/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
	);
	touch $(READLINE_DIR)/.configured

$(READLINE_DIR)/$(READLINE_BINARY): $(READLINE_DIR)/.configured
	$(MAKE)  -C $(READLINE_DIR)
	touch -c $(READLINE_DIR)/$(READLINE_BINARY)

$(STAGING_DIR)/$(READLINE_TARGET_BINARY): $(READLINE_DIR)/.configured
	$(MAKE) -C $(READLINE_DIR)  install
	touch -c $(STAGING_DIR)/$(READLINE_TARGET_BINARY)

# Install to Staging area
$(STAGING_DIR)/include/readline/readline.h: $(READLINE_DIR)/$(READLINE_BINARY)
	BUILD_CC=$(TARGET_CC) HOSTCC="$(HOSTCC)" CC=$(TARGET_CC) \
	$(MAKE1) DESTDIR=$(STAGING_DIR) -C $(READLINE_DIR) install;
	touch -c $(STAGING_DIR)/include/readline/readline.h


# Install only run-time to Target directory
$(TARGET_DIR)/include/readline/readline.h: $(READLINE_DIR)/$(READLINE_BINARY)
	BUILD_CC=$(TARGET_CC) HOSTCC="$(HOSTCC)" CC=$(TARGET_CC) \
	$(MAKE1) DESTDIR=$(TARGET_DIR) -C $(READLINE_DIR) install-shared
	touch -c $(TARGET_DIR)/include/readline/readline.h

readline: $(STAGING_DIR)/include/readline/readline.h

readline-target: $(TARGET_DIR)/include/readline/readline.h

readline-clean:
	$(MAKE) -C $(READLINE_DIR) uninstall
	-$(MAKE) -C $(READLINE_DIR) clean

readline-dirclean:
	rm -rf $(READLINE_DIR)

readline-source:  $(DL_DIR)/$(READLINE_SOURCE)

ifeq ($(strip $(BR2_READLINE)),y)
TARGETS+=readline
endif
ifeq ($(strip $(BR2_PACKAGE_READLINE_TARGET)),y)
TARGETS+=readline-target
endif
