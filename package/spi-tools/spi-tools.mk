################################################################################
#
# spi-tools
#
################################################################################

# git commit sha1 is used as there is no release tag with autotools support yet
SPI_TOOLS_VERSION = cc6a41fdcec60610703ba6db488c621c64952898
SPI_TOOLS_SITE = $(call github,cpb-,spi-tools,$(SPI_TOOLS_VERSION))
# autoreconf must be run as specified in package documentation
SPI_TOOLS_AUTORECONF = YES
SPI_TOOLS_LICENSE = GPLv2
SPI_TOOLS_LICENSE_FILES = LICENSE

# Package attempts to use git to obtain version, that fails within Buildroot.
# To avoid it, set the GIT_VERSION variable to the Buildroot package version.
define SPI_TOOLS_SET_VERSION
	$(SED) "s/^\(GIT_VERSION:=\).*/\1$(SPI_TOOLS_VERSION)/" \
		$(@D)/src/Makefile.am
endef

SPI_TOOLS_POST_PATCH_HOOKS = SPI_TOOLS_SET_VERSION

$(eval $(autotools-package))
