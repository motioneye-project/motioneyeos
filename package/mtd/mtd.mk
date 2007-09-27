ifeq ($(strip $(BR2_PACKAGE_MTD_UTILS)),y)
include package/mtd/mtd-utils/mtd.mk
endif
ifeq ($(strip $(BR2_PACKAGE_MTD_20061007)),y)
include package/mtd/20061007/mtd.mk
endif
ifeq ($(strip $(BR2_PACKAGE_MTD_20050122)),y)
include package/mtd/20050122/mtd.mk
endif
ifeq ($(strip $(BR2_PACKAGE_MTD_SNAPSHOT)),y)
include package/mtd/20050122/mtd.mk
endif
