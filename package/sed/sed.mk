#############################################################
#
# sed
#
#############################################################
SED_VERSION:=4.1.5
SED_SOURCE:=sed-$(SED_VERSION).tar.gz
SED_SITE:=$(BR2_GNU_MIRROR)/sed
SED_CAT:=$(ZCAT)
SED_DIR1:=$(TOOL_BUILD_DIR)/sed-$(SED_VERSION)
SED_DIR2:=$(BUILD_DIR)/sed-$(SED_VERSION)
SED_BINARY:=sed/sed
SED_TARGET_BINARY:=bin/sed
ifeq ($(strip $(BR2_LARGEFILE)),y)
SED_CPPFLAGS=-D_FILE_OFFSET_BITS=64
endif
#HOST_SED_DIR:=$(STAGING_DIR)
HOST_SED_DIR:=$(TOOL_BUILD_DIR)
SED:=$(HOST_SED_DIR)/bin/sed -i -e
HOST_SED_BINARY=$(shell package/sed/sedcheck.sh)
HOST_SED_IF_ANY=$(shell toolchain/dependencies/check-host-sed.sh)

$(DL_DIR)/$(SED_SOURCE):
	mkdir -p $(DL_DIR)
	$(WGET) -P $(DL_DIR) $(SED_SITE)/$(SED_SOURCE)

sed-source: $(DL_DIR)/$(SED_SOURCE)


#############################################################
#
# build sed for use on the host system
#
#############################################################
$(SED_DIR1)/.unpacked: $(DL_DIR)/$(SED_SOURCE)
	mkdir -p $(TOOL_BUILD_DIR)
	mkdir -p $(HOST_SED_DIR)/bin
	$(SED_CAT) $(DL_DIR)/$(SED_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(SED_DIR1) package/sed/ configure.patch
	$(CONFIG_UPDATE) $(SED_DIR1)/config
	touch $@

$(SED_DIR1)/.configured: $(SED_DIR1)/.unpacked
	(cd $(SED_DIR1); rm -rf config.cache; \
		./configure \
		--prefix=/usr \
	)
	touch $@

$(SED_DIR1)/$(SED_BINARY): $(SED_DIR1)/.configured
	$(MAKE) -C $(SED_DIR1)

# This stuff is needed to work around GNU make deficiencies
build-sed-host-binary: $(SED_DIR1)/$(SED_BINARY)
	@if [ -L $(HOST_SED_DIR)/$(SED_TARGET_BINARY) ]; then \
		rm -f $(HOST_SED_DIR)/$(SED_TARGET_BINARY); \
	fi
	@if [ ! -f $(HOST_SED_DIR)/$(SED_TARGET_BINARY) \
	      -o $(HOST_SED_DIR)/$(SED_TARGET_BINARY) \
	      -ot $(SED_DIR1)/$(SED_BINARY) ]; then \
		set -x; \
		mkdir -p $(HOST_SED_DIR)/bin; \
		$(MAKE) DESTDIR=$(HOST_SED_DIR) -C $(SED_DIR1) install; \
		mv $(HOST_SED_DIR)/usr/bin/sed $(HOST_SED_DIR)/bin/; \
		rm -rf $(HOST_SED_DIR)/share/locale; \
		rm -rf $(HOST_SED_DIR)/usr/share/doc; \
	fi
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(HOST_SED_DIR)/usr/man/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(HOST_SED_DIR)/usr/share/man
endif

$(HOST_SED_DIR)/$(SED_TARGET_BINARY):
	if [ ! -e "$(HOST_SED_DIR)/$(SED_TARGET_BINARY)" ]; then \
		mkdir -p "$(HOST_SED_DIR)/bin"; \
		rm -f "$(HOST_SED_DIR)/$(SED_TARGET_BINARY)"; \
		ln -sf "$(HOST_SED_IF_ANY)" \
			"$(HOST_SED_DIR)/$(SED_TARGET_BINARY)"; \
	fi

.PHONY: sed host-sed use-sed-host-binary

use-sed-host-binary: $(HOST_SED_DIR)/$(SED_TARGET_BINARY)

host-sed: $(HOST_SED_BINARY)

ifeq ($(HOST_SED_BINARY),build-sed-host-binary)
host-sed-clean:
	$(MAKE) DESTDIR=$(HOST_SED_DIR) -C $(SED_DIR1) uninstall
	-$(MAKE) -C $(SED_DIR1) clean

host-sed-dirclean:
	rm -rf $(SED_DIR1)

else
host-sed-clean host-sed-dirclean:

endif

#############################################################
#
# build sed for use on the target system
#
#############################################################
$(SED_DIR2)/.unpacked: $(DL_DIR)/$(SED_SOURCE)
	$(SED_CAT) $(DL_DIR)/$(SED_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(SED_DIR2)/config
	touch $@

$(SED_DIR2)/.configured: $(SED_DIR2)/.unpacked
	(cd $(SED_DIR2); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CPPFLAGS="$(SED_CFLAGS)" \
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
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--include=$(STAGING_DIR)/usr/include \
		$(DISABLE_NLS) \
	)
	touch $@

$(SED_DIR2)/$(SED_BINARY): $(SED_DIR2)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(SED_DIR2)

# This stuff is needed to work around GNU make deficiencies
sed-target_binary: $(SED_DIR2)/$(SED_BINARY)
	@if [ -L $(TARGET_DIR)/$(SED_TARGET_BINARY) ]; then \
		rm -f $(TARGET_DIR)/$(SED_TARGET_BINARY); \
	fi

	@if [ ! -f $(SED_DIR2)/$(SED_BINARY) \
	      -o $(TARGET_DIR)/$(SED_TARGET_BINARY) \
	      -ot $(SED_DIR2)/$(SED_BINARY) ]; then \
		set -x; \
		$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(SED_DIR2) install; \
		mv $(TARGET_DIR)/usr/bin/sed $(TARGET_DIR)/bin/; \
		rm -rf $(TARGET_DIR)/share/locale; \
		rm -rf $(TARGET_DIR)/usr/share/doc; \
	fi
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/man
endif

sed: uclibc sed-target_binary

sed-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(SED_DIR2) uninstall
	-$(MAKE) -C $(SED_DIR2) clean

sed-dirclean:
	rm -rf $(SED_DIR2)


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_SED)),y)
TARGETS+=sed
endif
