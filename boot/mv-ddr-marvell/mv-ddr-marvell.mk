################################################################################
#
# mv-ddr-marvell
#
################################################################################

# This is the commit for mv_ddr-armada-18.09.2
MV_DDR_MARVELL_VERSION = 99d772547314f84921268d57e53d8769197d3e21
MV_DDR_MARVELL_SITE = $(call github,MarvellEmbeddedProcessors,mv-ddr-marvell,$(MV_DDR_MARVELL_VERSION))
MV_DDR_MARVELL_LICENSE = GPL-2.0+ or LGPL-2.1 with freertos-exception-2.0, BSD-3-Clause, Marvell Commercial
MV_DDR_MARVELL_LICENSE_FILES = ddr3_init.c

$(eval $(generic-package))
