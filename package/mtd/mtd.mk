#############################################################
#
# mtd provides jffs2 utilities
#
#############################################################
MTD_VERSION:=1.3.1
MTD_SOURCE:=mtd-utils-$(MTD_VERSION).tar.bz2
MTD_SITE:=ftp://ftp.infradead.org/pub/mtd-utils
MTD_DIR:=$(BUILD_DIR)/mtd-utils-$(MTD_VERSION)
MTD_HOST_DIR:= $(MTD_DIR)-host
MTD_CAT:=$(BZCAT)

#############################################################
#
# Build mkfs.jffs2 and sumtool for use on the local host system if
# needed by target/jffs2root.
#
#############################################################
MKFS_JFFS2 := $(HOST_DIR)/usr/sbin/mkfs.jffs2
SUMTOOL := $(HOST_DIR)/usr/sbin/sumtool

$(DL_DIR)/$(MTD_SOURCE):
	$(call DOWNLOAD,$(MTD_SITE),$(MTD_SOURCE))

$(MTD_HOST_DIR)/.unpacked: $(DL_DIR)/$(MTD_SOURCE)
	mkdir -p $(@D)
	$(MTD_CAT) $^ | tar $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MTD_HOST_DIR) \
		package/mtd/ mtd-utils-\*.patch
	touch $@

$(MTD_HOST_DIR)/mkfs.jffs2: $(MTD_HOST_DIR)/.unpacked
	CC="$(HOSTCC)" CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS)" \
		CROSS= $(MAKE) BUILDDIR=$(MTD_HOST_DIR) \
		WITHOUT_XATTR=1 -C $(MTD_HOST_DIR) $@

$(MKFS_JFFS2): $(MTD_HOST_DIR)/mkfs.jffs2
	install -m 0755 -D $^ $@

$(MTD_HOST_DIR)/sumtool: $(MTD_HOST_DIR)/.unpacked
	CC="$(HOSTCC)" CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS)" \
		CROSS= $(MAKE) BUILDDIR=$(MTD_HOST_DIR) \
		WITHOUT_XATTR=1 -C $(MTD_HOST_DIR) $@

$(SUMTOOL): $(MTD_HOST_DIR)/sumtool
	install -m 0755 $^ $@

mtd-host: host-lzo $(MKFS_JFFS2) $(SUMTOOL)

mtd-host-source: $(DL_DIR)/$(MTD_SOURCE)

mtd-host-clean:
	-$(MAKE) -C $(MTD_HOST_DIR) clean
	rm -f $(MKFS_JFFS2) $(SUMTOOL)

mtd-host-dirclean:
	rm -rf $(MTD_HOST_DIR)

#############################################################
#
# build mtd for use on the target system
#
#############################################################
$(MTD_DIR)/.unpacked: $(DL_DIR)/$(MTD_SOURCE)
	$(MTD_CAT) $(DL_DIR)/$(MTD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MTD_DIR) package/mtd/ mtd-utils-\*.patch
	touch $@

MTD_TARGETS_$(BR2_PACKAGE_MTD_DOCFDISK)		+= docfdisk
MTD_TARGETS_$(BR2_PACKAGE_MTD_DOC_LOADBIOS)	+= doc_loadbios
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASHCP)		+= flashcp
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_ERASE)	+= flash_erase
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_ERASEALL)	+= flash_eraseall
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_INFO)	+= flash_info
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_LOCK)	+= flash_lock
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_OTP_DUMP)	+= flash_otp_dump
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_OTP_INFO)	+= flash_otp_info
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_UNLOCK)	+= flash_unlock
MTD_TARGETS_$(BR2_PACKAGE_MTD_FTL_CHECK)	+= ftl_check
MTD_TARGETS_$(BR2_PACKAGE_MTD_FTL_FORMAT)	+= ftl_format
MTD_TARGETS_$(BR2_PACKAGE_MTD_JFFS2DUMP)	+= jffs2dump
MTD_TARGETS_$(BR2_PACKAGE_MTD_MKFSJFFS2)	+= mkfs.jffs2
MTD_TARGETS_$(BR2_PACKAGE_MTD_MTD_DEBUG)	+= mtd_debug
MTD_TARGETS_$(BR2_PACKAGE_MTD_NANDDUMP)		+= nanddump
MTD_TARGETS_$(BR2_PACKAGE_MTD_NANDTEST)		+= nandtest
MTD_TARGETS_$(BR2_PACKAGE_MTD_NANDWRITE)	+= nandwrite
MTD_TARGETS_$(BR2_PACKAGE_MTD_NFTLDUMP)		+= nftldump
MTD_TARGETS_$(BR2_PACKAGE_MTD_NFTL_FORMAT)	+= nftl_format
MTD_TARGETS_$(BR2_PACKAGE_MTD_RECV_IMAGE)	+= recv_image
MTD_TARGETS_$(BR2_PACKAGE_MTD_RFDDUMP)		+= rfddump
MTD_TARGETS_$(BR2_PACKAGE_MTD_RFDFORMAT)	+= rfdformat
MTD_TARGETS_$(BR2_PACKAGE_MTD_SERVE_IMAGE)	+= serve_image
MTD_TARGETS_$(BR2_PACKAGE_MTD_SUMTOOL)		+= sumtool

MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_MTDINFO)	+= mtdinfo
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIATTACH)	+= ubiattach
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBICRC32)	+= ubicrc32
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIDETACH)	+= ubidetach
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIFORMAT)	+= ubiformat
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIMKVOL)	+= ubimkvol
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBINFO)	+= ubinfo
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBINIZE)	+= ubinize
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIRENAME)	+= ubirename
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIRMVOL)	+= ubirmvol
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIRSVOL)	+= ubirsvol
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIUPDATEVOL)	+= ubiupdatevol

MTD_TARGETS := $(addprefix $(MTD_DIR)/, $(MTD_TARGETS_y))
MTD_UBI_TARGETS := $(addprefix $(MTD_DIR)/ubi-utils/, $(MTD_TARGETS_UBI_y))
MTD_BUILD_TARGETS := $(MTD_TARGETS) $(MTD_UBI_TARGETS)

$(MTD_BUILD_TARGETS): $(MTD_DIR)/.unpacked
ifneq ($(MTD_TARGETS),)
	$(MAKE) LDFLAGS="$(TARGET_LDFLAGS)" \
		BUILDDIR=$(MTD_DIR) \
		CROSS=$(TARGET_CROSS) CC=$(TARGET_CC) \
		WITHOUT_XATTR=1 WITHOUT_LARGEFILE=1 \
		-C $(MTD_DIR) $(MTD_TARGETS)
endif
ifneq ($(MTD_UBI_TARGETS),)
	$(MAKE) LDFLAGS="$(TARGET_LDFLAGS)" \
		BUILDDIR=$(MTD_DIR)/ubi-utils \
		CROSS=$(TARGET_CROSS) CC=$(TARGET_CC) \
		WITHOUT_XATTR=1 WITHOUT_LARGEFILE=1 \
		-C $(MTD_DIR)/ubi-utils $(MTD_UBI_TARGETS)
endif

MTD_TARGET_BINS := $(addprefix $(TARGET_DIR)/usr/sbin/,\
		 $(MTD_TARGETS_y) $(MTD_TARGETS_UBI_y))

$(MTD_TARGET_BINS): $(MTD_BUILD_TARGETS)
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -m 0755 $^ $(TARGET_DIR)/usr/sbin

mtd: $(if $(BR2_PACKAGE_MTD_MKFSJFFS2),zlib lzo) $(MTD_TARGET_BINS)

mtd-source: $(DL_DIR)/$(MTD_SOURCE)

mtd-clean:
	-$(MAKE) -C $(MTD_DIR) clean
	rm -f $(MTD_TARGET_BINS)

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
