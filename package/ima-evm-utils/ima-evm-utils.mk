################################################################################
#
# ima-evm-utils
#
################################################################################

IMA_EVM_UTILS_VERSION = 1.2.1
IMA_EVM_UTILS_SITE = http://downloads.sourceforge.net/project/linux-ima/ima-evm-utils
IMA_EVM_UTILS_LICENSE = GPL-2.0
IMA_EVM_UTILS_LICENSE_FILES = COPYING
IMA_EVM_UTILS_DEPENDENCIES = host-pkgconf keyutils openssl

# Tarball doesn't contain configure
IMA_EVM_UTILS_AUTORECONF = YES

# Build and install in the src subdirectory. This avoids building the
# documentation, which requires asciidoc and xsltproc. Note that configure still
# needs to be run from the top dir, so _SUBDIR can't be used.

define IMA_EVM_UTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src all
endef

define IMA_EVM_UTILS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR="$(STAGING_DIR)" -C $(@D)/src install
endef

define IMA_EVM_UTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR="$(TARGET_DIR)" -C $(@D)/src install
endef

$(eval $(autotools-package))
