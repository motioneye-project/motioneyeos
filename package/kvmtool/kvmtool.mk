################################################################################
#
# kvmtool
#
################################################################################

KVMTOOL_VERSION = f77d646ba01d04be5aad9449ac00719c043fe36e
KVMTOOL_SITE = $(BR2_KERNEL_MIRROR)/scm/linux/kernel/git/will/kvmtool.git
KVMTOOL_SITE_METHOD = git
KVMTOOL_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_BINUTILS),binutils) \
	$(if $(BR2_PACKAGE_DTC),dtc) \
	$(if $(BR2_PACKAGE_LIBAIO),libaio) \
	$(if $(BR2_PACKAGE_LIBGTK3),libgtk3) \
	$(if $(BR2_PACKAGE_LIBVNCSERVER),libvncserver) \
	$(if $(BR2_PACKAGE_SDL),sdl) \
	$(if $(BR2_PACKAGE_ZLIB),zlib)
KVMTOOL_LICENSE = GPL-2.0
KVMTOOL_LICENSE_FILES = COPYING

# Disable -Werror, otherwise musl is not happy
KVMTOOL_MAKE_OPTS = \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	LDFLAGS="$(TARGET_LDFLAGS) $(KVMTOOL_EXTRA_LDFLAGS)" \
	WERROR=0

define KVMTOOL_BUILD_CMDS
	$(TARGET_MAKE_ENV) ARCH=$(KERNEL_ARCH) $(MAKE) -C $(@D) $(KVMTOOL_MAKE_OPTS)
endef

define KVMTOOL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) ARCH=$(KERNEL_ARCH) $(MAKE) -C $(@D) \
		$(KVMTOOL_MAKE_OPTS) install DESTDIR=$(TARGET_DIR) prefix=/usr
endef

$(eval $(generic-package))
