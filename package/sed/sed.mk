#############################################################
#
# sed
#
#############################################################
SED_VERSION:=4.2.1
SED_SOURCE:=sed-$(SED_VERSION).tar.gz
SED_SITE:=$(BR2_GNU_MIRROR)/sed
SED_CAT:=$(ZCAT)
SED_DIR2:=$(BUILD_DIR)/sed-$(SED_VERSION)
SED_BINARY:=sed/sed
SED_TARGET_BINARY:=bin/sed
ifeq ($(BR2_LARGEFILE),y)
SED_CPPFLAGS=-D_FILE_OFFSET_BITS=64
endif

$(DL_DIR)/$(SED_SOURCE):
	mkdir -p $(DL_DIR)
	$(call DOWNLOAD,$(SED_SITE),$(SED_SOURCE))

sed-source: $(DL_DIR)/$(SED_SOURCE)

$(SED_DIR2)/.unpacked: $(DL_DIR)/$(SED_SOURCE)
	$(SED_CAT) $(DL_DIR)/$(SED_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(SED_DIR2)/build-aux
	touch $@

$(SED_DIR2)/.configured: $(SED_DIR2)/.unpacked
	(cd $(SED_DIR2); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CPPFLAGS="$(SED_CPPFLAGS)" \
		./configure $(QUIET) \
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
		--include=$(STAGING_DIR)/usr/include \
		$(DISABLE_NLS) \
	)
	touch $@

$(SED_DIR2)/$(SED_BINARY): $(SED_DIR2)/.configured
	$(MAKE) -C $(SED_DIR2)

# This stuff is needed to work around GNU make deficiencies
sed-target_binary: $(SED_DIR2)/$(SED_BINARY)
	@if [ -L $(TARGET_DIR)/$(SED_TARGET_BINARY) ]; then \
		rm -f $(TARGET_DIR)/$(SED_TARGET_BINARY); \
	fi

	@if [ ! -f $(SED_DIR2)/$(SED_BINARY) \
	      -o $(TARGET_DIR)/$(SED_TARGET_BINARY) \
	      -ot $(SED_DIR2)/$(SED_BINARY) ]; then \
		set -x; \
		$(MAKE) DESTDIR=$(TARGET_DIR) CC="$(TARGET_CC)" -C $(SED_DIR2) install; \
		mv $(TARGET_DIR)/usr/bin/sed $(TARGET_DIR)/bin/; \
		rm -rf $(TARGET_DIR)/share/locale; \
		rm -rf $(TARGET_DIR)/usr/share/doc; \
	fi

sed: sed-target_binary

sed-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC="$(TARGET_CC)" -C $(SED_DIR2) uninstall
	-$(MAKE) -C $(SED_DIR2) clean

sed-dirclean:
	rm -rf $(SED_DIR2)


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_SED),y)
TARGETS+=sed
endif
