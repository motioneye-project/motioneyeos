################################################################################
#
# spi-tools
#
################################################################################

SPI_TOOLS_VERSION = 0.8.1
SPI_TOOLS_SITE = $(call github,cpb-,spi-tools,$(SPI_TOOLS_VERSION))
# autoreconf must be run as specified in package documentation
SPI_TOOLS_AUTORECONF = YES
SPI_TOOLS_LICENSE = GPLv2
SPI_TOOLS_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
