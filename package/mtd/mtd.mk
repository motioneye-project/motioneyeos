#############################################################
#
# mtd provides jffs2 utilities
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MTD_SNAPSHOT)),y)
# Be aware that this changes daily....
TODAY:=$(shell date -u +%Y%m%d)
MTD_DL_SOURCE:=mtd-snapshot-$(TODAY).tar.bz2
MTD_CAT:=$(BZCAT)
MTD_SOURCE:=mtd-snapshot.tar.bz2
MTD_SITE:=ftp://ftp.uk.linux.org/pub/people/dwmw2/mtd/cvs
MTD_HOST_DIR := $(TOOL_BUILD_DIR)/mtd_snapshot
MTD_DIR:=$(BUILD_DIR)/mtd_snapshot
else
MTD_SOURCE:=$(strip $(subst ",, $(BR2_PACKAGE_MTD_ORIG_STRING)))
#"))
MTD_SITE:=http://ftp.debian.org/debian/pool/main/m/mtd
MTD_HOST_DIR := $(TOOL_BUILD_DIR)/mtd_orig
MTD_DIR:=$(BUILD_DIR)/mtd_orig
MTD_CAT:=$(ZCAT)
endif



#############################################################
#
# Build mkfs.jffs2 for use on the local host system if
# needed by target/jffs2root.
#
#############################################################
MKFS_JFFS2 := $(MTD_HOST_DIR)/util/mkfs.jffs2

ifeq ($(strip $(BR2_PACKAGE_MTD_SNAPSHOT)),y)
$(DL_DIR)/$(MTD_SOURCE):
	$(WGET) -P $(DL_DIR) $(MTD_SITE)/$(MTD_DL_SOURCE)
	mv $(DL_DIR)/$(MTD_DL_SOURCE) $(DL_DIR)/$(MTD_SOURCE)

$(MTD_HOST_DIR)/.unpacked: $(DL_DIR)/$(MTD_SOURCE_GENERIC)
	$(MTD_CAT) $(DL_DIR)/$(MTD_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	mv $(TOOL_BUILD_DIR)/$(shell tar tjf $(DL_DIR)/$(MTD_SOURCE) \
		| head -n 1 | xargs basename) $(MTD_HOST_DIR)
	touch $(MTD_HOST_DIR)/.unpacked
else
ifneq ($(MTD_SOURCE),)
$(DL_DIR)/$(MTD_SOURCE):
	$(WGET) -P $(DL_DIR) $(MTD_SITE)/$(MTD_SOURCE)
endif

$(MTD_HOST_DIR)/.unpacked: $(DL_DIR)/$(MTD_SOURCE)
	$(MTD_CAT) $(DL_DIR)/$(MTD_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	mv $(TOOL_BUILD_DIR)/$(shell tar tzf $(DL_DIR)/$(MTD_SOURCE) | head -n 1 \
		| xargs basename) $(MTD_HOST_DIR)
	toolchain/patch-kernel.sh $(MTD_HOST_DIR) \
		package/mtd \*.patch
	touch $(MTD_HOST_DIR)/.unpacked
endif

$(MTD_HOST_DIR)/util/mkfs.jffs2: $(MTD_HOST_DIR)/.unpacked
	CC="$(HOSTCC)" CROSS= CFLAGS=-I$(LINUX_HEADERS_DIR)/include \
		$(MAKE) LINUXDIR=$(LINUX_DIR) -C $(MTD_HOST_DIR)/util mkfs.jffs2

mtd-host: $(MKFS_JFFS2)

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
ifeq ($(strip $(BR2_PACKAGE_MTD_SNAPSHOT)),y)
	mv $(BUILD_DIR)/$(shell tar tjf $(DL_DIR)/$(MTD_SOURCE) \
		| head -n 1 | xargs basename) $(MTD_DIR)
	touch $(MTD_DIR)/.unpacked
else
	mv $(BUILD_DIR)/$(shell tar tzf $(DL_DIR)/$(MTD_SOURCE) \
		| head -n 1 | xargs basename) $(MTD_DIR)
	toolchain/patch-kernel.sh $(MTD_DIR) \
		package/mtd \*.patch
	touch $(MTD_DIR)/.unpacked
endif

MTD_TARGETS_n :=
MTD_TARGETS_y :=

MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_ERASE)		+= flash_erase
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_ERASEALL)		+= flash_eraseall
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_INFO)		+= flash_info
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_LOCK)		+= flash_lock
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_UNLOCK)		+= flash_unlock
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASHCP)			+= flashcp
MTD_TARGETS_$(BR2_PACKAGE_MTD_MKFSJFFS2)		+= mkfs.jffs2
MTD_TARGETS_$(BR2_PACKAGE_MTD_MKFSJFFS)			+= mkfs.jffs
MTD_TARGETS_$(BR2_PACKAGE_MTD_JFFS2DUMP)		+= jffs2dump
MTD_TARGETS_$(BR2_PACKAGE_MTD_JFFS3DUMP)		+= jffs3dump
MTD_TARGETS_$(BR2_PACKAGE_MTD_SUMTOOL)			+= sumtool
MTD_TARGETS_$(BR2_PACKAGE_MTD_FTL_CHECK)		+= ftl_check
MTD_TARGETS_$(BR2_PACKAGE_MTD_FTL_FORMAT)		+= ftl_format
MTD_TARGETS_$(BR2_PACKAGE_MTD_NFTLDUMP)			+= nftldump
MTD_TARGETS_$(BR2_PACKAGE_MTD_NFTL_FORMAT)		+= nftl_format
MTD_TARGETS_$(BR2_PACKAGE_MTD_NANDDUMP)			+= nanddump
MTD_TARGETS_$(BR2_PACKAGE_MTD_NANDWRITE)		+= nandwrite
MTD_TARGETS_$(BR2_PACKAGE_MTD_MTD_DEBUG)		+= mtd_debug
MTD_TARGETS_$(BR2_PACKAGE_MTD_DOCFDISK)			+= docfdisk
MTD_TARGETS_$(BR2_PACKAGE_MTD_DOC_LOADBIOS)		+= doc_loadbios

MTD_BUILD_TARGETS := $(addprefix $(MTD_DIR)/util/, $(MTD_TARGETS_y))

$(MTD_BUILD_TARGETS): $(MTD_DIR)/.unpacked
	CFLAGS="-I$(LINUX_HEADERS_DIR)/include $(TARGET_CFLAGS)" \
	$(MAKE)	CC=$(TARGET_CC) LINUXDIR=$(LINUX_DIR) -C $(MTD_DIR)/util

MTD_TARGETS := $(addprefix $(TARGET_DIR)/usr/sbin/, $(MTD_TARGETS_y))

$(MTD_TARGETS): $(TARGET_DIR)/usr/sbin/% : $(MTD_DIR)/util/%
	cp -f $< $@
	$(STRIP) $@

mtd: zlib $(MTD_TARGETS)

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
ifeq ($(strip $(BR2_PACKAGE_MTD)),y)
TARGETS+=mtd
endif
