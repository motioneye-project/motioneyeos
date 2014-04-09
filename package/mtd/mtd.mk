################################################################################
#
# mtd
#
################################################################################

MTD_VERSION = 1.5.1
MTD_SOURCE = mtd-utils-$(MTD_VERSION).tar.bz2
MTD_SITE = ftp://ftp.infradead.org/pub/mtd-utils
MTD_LICENSE = GPLv2
MTD_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_MTD_MKFSJFFS2),y)
MTD_DEPENDENCIES = zlib lzo
endif

ifeq ($(BR2_PACKAGE_MTD_MKFSUBIFS),y)
MTD_DEPENDENCIES += util-linux zlib lzo
endif

ifeq ($(BR2_PACKAGE_BUSYBOX),y)
MTD_DEPENDENCIES += busybox
endif

HOST_MTD_DEPENDENCIES = host-zlib host-lzo host-e2fsprogs

define HOST_MTD_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE1) \
		CROSS= BUILDDIR=$(@D) WITHOUT_XATTR=1 -C $(@D)
endef

define HOST_MTD_INSTALL_CMDS
	$(MAKE1) BUILDDIR=$(@D) DESTDIR=$(HOST_DIR) -C $(@D) install
endef

MKFS_JFFS2 = $(HOST_DIR)/usr/sbin/mkfs.jffs2
SUMTOOL = $(HOST_DIR)/usr/sbin/sumtool

MTD_TARGETS_$(BR2_PACKAGE_MTD_DOCFDISK)		+= docfdisk
MTD_TARGETS_$(BR2_PACKAGE_MTD_DOC_LOADBIOS)	+= doc_loadbios
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASHCP)		+= flashcp
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_ERASE)	+= flash_erase
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_LOCK)	+= flash_lock
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_OTP_DUMP)	+= flash_otp_dump
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_OTP_INFO)	+= flash_otp_info
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_OTP_LOCK)	+= flash_otp_lock
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_OTP_WRITE)	+= flash_otp_write
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
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIBLOCK)	+= ubiblock

MTD_TARGETS_y += $(addprefix ubi-utils/,$(MTD_TARGETS_UBI_y))
MTD_TARGETS_$(BR2_PACKAGE_MTD_MKFSUBIFS) += mkfs.ubifs/mkfs.ubifs

# only call make if atleast a single tool is enabled
ifneq ($(MTD_TARGETS_y),)

define MTD_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE1) CROSS=$(TARGET_CROSS) \
		BUILDDIR=$(@D) WITHOUT_XATTR=1 WITHOUT_LARGEFILE=1 -C $(@D) \
		$(addprefix $(@D)/,$(MTD_TARGETS_y))
endef

endif

define MTD_INSTALL_TARGET_CMDS
 for f in $(MTD_TARGETS_y) ; do \
  install -D -m 0755 $(@D)/$$f $(TARGET_DIR)/usr/sbin/$${f##*/} ; \
 done
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
