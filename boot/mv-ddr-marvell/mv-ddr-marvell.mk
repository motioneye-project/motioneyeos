################################################################################
#
# mv-ddr-marvell
#
################################################################################

# This is the commit for mv_ddr-armada-18.12.0
MV_DDR_MARVELL_VERSION = 618dadd1491eb2f7b2fd74313c04f7accddae475
MV_DDR_MARVELL_SITE = $(call github,MarvellEmbeddedProcessors,mv-ddr-marvell,$(MV_DDR_MARVELL_VERSION))
MV_DDR_MARVELL_LICENSE = GPL-2.0+ or LGPL-2.1 with freertos-exception-2.0, BSD-3-Clause, Marvell Commercial
MV_DDR_MARVELL_LICENSE_FILES = ddr3_init.c

$(eval $(generic-package))
