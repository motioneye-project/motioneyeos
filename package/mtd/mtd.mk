ifeq ($(strip $(BR2_PACKAGE_MTD_EXPERIMENTAL)),y)
include package/mtd/20061007/mtd.mk
else
include package/mtd/20050122/mtd.mk
endif
