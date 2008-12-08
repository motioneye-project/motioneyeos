#############################################################
#
# mtd provides jffs2 utilities
#
#############################################################
MTD_VERSION:=fcb52ccc99679460640386c297023f852b108f68
MTD_SOURCE:=mtd-utils-$(MTD_VERSION).tar.gz
MTD_URL:=http://git.infradead.org/mtd-utils.git?a=snapshot;h=$(MTD_VERSION);sf=tgz
MTD_HOST_DIR:= $(TOOL_BUILD_DIR)/mtd-utils-$(MTD_VERSION)
MTD_DIR:=$(BUILD_DIR)/mtd-utils-$(MTD_VERSION)
MTD_CAT:=$(ZCAT)
MTD_NAME:=mtd-utils

#############################################################
#
# Build mkfs.jffs2 and sumtool for use on the local host system if
# needed by target/jffs2root.
#
#############################################################
MKFS_JFFS2 := $(MTD_HOST_DIR)/mkfs.jffs2
SUMTOOL := $(MTD_HOST_DIR)/sumtool

$(DL_DIR)/$(MTD_SOURCE):
	$(WGET) -O $(DL_DIR)/$(MTD_SOURCE) "$(MTD_URL)"

$(MTD_HOST_DIR)/.unpacked: $(DL_DIR)/$(MTD_SOURCE)
	$(MTD_CAT) $(DL_DIR)/$(MTD_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	rm -rf $(MTD_HOST_DIR)
	mv $(TOOL_BUILD_DIR)/$(MTD_NAME) $(MTD_HOST_DIR)
	toolchain/patch-kernel.sh $(MTD_HOST_DIR) \
		package/mtd/mtd-utils.git mtd-utils-all\*.patch
	toolchain/patch-kernel.sh $(MTD_HOST_DIR) \
		package/mtd/mtd-utils.git mtd-utils-host\*.patch
	touch $@


$(MKFS_JFFS2): $(MTD_HOST_DIR)/.unpacked
	CC="$(HOSTCC)" CROSS= CFLAGS=-I$(LINUX_HEADERS_DIR)/include \
		$(MAKE) \
		BUILDDIR=$(MTD_HOST_DIR) WITHOUT_XATTR=1 \
		-C $(MTD_HOST_DIR) mkfs.jffs2

$(SUMTOOL): $(MTD_HOST_DIR)/.unpacked
	CC="$(HOSTCC)" CROSS= CFLAGS=-I$(LINUX_HEADERS_DIR)/include \
		$(MAKE) \
		BUILDDIR=$(MTD_HOST_DIR) WITHOUT_XATTR=1 \
		-C $(MTD_HOST_DIR) sumtool

mtd-host: $(MKFS_JFFS2) $(SUMTOOL)

mtd-host-source: $(DL_DIR)/$(MTD_SOURCE)

mtd-host-clean:
	-$(MAKE) -C $(MTD_HOST_DIR) clean

mtd-host-dirclean:
	rm -rf $(MTD_HOST_DIR)

#############################################################
#
# build mtd for use on the target system
#
#############################################################
$(MTD_DIR)/.unpacked: $(DL_DIR)/$(MTD_SOURCE)
	$(MTD_CAT) $(DL_DIR)/$(MTD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	rm -rf $(MTD_DIR)
	mv $(BUILD_DIR)/$(MTD_NAME) $(MTD_DIR)
	toolchain/patch-kernel.sh $(MTD_DIR) package/mtd/mtd-utils.git mtd-utils-all\*.patch
	toolchain/patch-kernel.sh $(MTD_DIR) package/mtd/mtd-utils.git mtd-utils-target\*.patch
	touch $@

MTD_TARGETS_n :=
MTD_TARGETS_y :=

MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_ERASE) += flash_erase
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_ERASEALL) += flash_eraseall
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_INFO) += flash_info
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_LOCK) += flash_lock
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_UNLOCK) += flash_unlock
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASHCP) += flashcp
MTD_TARGETS_$(BR2_PACKAGE_MTD_MKFSJFFS2) += mkfs.jffs2
MTD_TARGETS_$(BR2_PACKAGE_MTD_JFFS2DUMP) += jffs2dump
MTD_TARGETS_$(BR2_PACKAGE_MTD_SUMTOOL) += sumtool
MTD_TARGETS_$(BR2_PACKAGE_MTD_FTL_CHECK) += ftl_check
MTD_TARGETS_$(BR2_PACKAGE_MTD_FTL_FORMAT) += ftl_format
MTD_TARGETS_$(BR2_PACKAGE_MTD_NFTLDUMP) += nftldump
MTD_TARGETS_$(BR2_PACKAGE_MTD_NFTL_FORMAT) += nftl_format
MTD_TARGETS_$(BR2_PACKAGE_MTD_NANDDUMP) += nanddump
MTD_TARGETS_$(BR2_PACKAGE_MTD_NANDTEST) += nandtest
MTD_TARGETS_$(BR2_PACKAGE_MTD_NANDWRITE) += nandwrite
MTD_TARGETS_$(BR2_PACKAGE_MTD_MTD_DEBUG) += mtd_debug
MTD_TARGETS_$(BR2_PACKAGE_MTD_DOCFDISK) += docfdisk
MTD_TARGETS_$(BR2_PACKAGE_MTD_DOC_LOADBIOS) += doc_loadbios

MTD_TARGETS_UBI_n :=
MTD_TARGETS_UBI_y :=

MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIATTACH) += ubiattach
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBICRC32) += ubicrc32
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIDETACH) += ubidetach
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIMIRROR) += ubimirror
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIMKVOL) += ubimkvol
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBINFO) += ubinfo
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIRMVOL) += ubirmvol
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIUPDATEVOL) += ubiupdatevol

MTD_BUILD_TARGETS := $(addprefix $(MTD_DIR)/, $(MTD_TARGETS_y)) $(addprefix $(MTD_DIR)/ubi-utils/, $(MTD_TARGETS_UBI_y))

$(MTD_BUILD_TARGETS): $(MTD_DIR)/.unpacked
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(MAKE1) OPTFLAGS="-DNEED_BCOPY -Dbcmp=memcmp -I$(STAGING_DIR)/usr/include $(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
	       BUILDDIR=$(MTD_DIR) \
	       CROSS=$(TARGET_CROSS) CC=$(TARGET_CC) WITHOUT_XATTR=1 -C $(MTD_DIR)

MTD_TARGETS := $(addprefix $(TARGET_DIR)/usr/sbin/, $(MTD_TARGETS_y))
MTD_UBI_TARGETS := $(addprefix $(TARGET_DIR)/usr/sbin/, $(MTD_TARGETS_UBI_y))

$(MTD_TARGETS): $(TARGET_DIR)/usr/sbin/% : $(MTD_DIR)/%
	cp -f $< $@
	$(STRIPCMD) $@

$(MTD_UBI_TARGETS): $(TARGET_DIR)/usr/sbin/% : $(MTD_DIR)/ubi-utils/%
	cp -f $< $@
	$(STRIPCMD) $@

mtd: zlib lzo $(MTD_TARGETS) $(MTD_UBI_TARGETS)

mtd-source: $(DL_DIR)/$(MTD_SOURCE)

mtd-clean:
	-$(MAKE) -C $(MTD_DIR) clean

mtd-dirclean:
	rm -rf $(MTD_DIR)


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_MTD),y)
TARGETS+=mtd
endif
