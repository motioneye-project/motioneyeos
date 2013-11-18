################################################################################
#
# pciutils
#
################################################################################

PCIUTILS_VERSION = 3.2.1
PCIUTILS_SITE = ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci
PCIUTILS_INSTALL_STAGING = YES
PCIUTILS_LICENSE = GPLv2+
PCIUTILS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_ZLIB),y)
	PCIUTILS_ZLIB=yes
	PCIUTILS_DEPENDENCIES += zlib
else
	PCIUTILS_ZLIB=no
endif

PCIUTILS_DNS=no

ifeq ($(BR2_PACKAGE_KMOD),y)
	PCIUTILS_DEPENDENCIES += kmod
	PCIUTILS_KMOD = yes
else
	PCIUTILS_KMOD = no
endif

ifeq ($(BR2_PREFER_STATIC_LIB),y)
	PCIUTILS_SHARED=no
else
	PCIUTILS_SHARED=yes
endif

PCIUTILS_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	HOST="$(KERNEL_ARCH)-linux" \
	OPT="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	RANLIB=$(TARGET_RANLIB) \
	AR=$(TARGET_AR) \
	ZLIB=$(PCIUTILS_ZLIB) \
	DNS=$(PCIUTILS_DNS) \
	LIBKMOD=$(PCIUTILS_KMOD) \
	SHARED=$(PCIUTILS_SHARED)

# Build after busybox since it's got a lightweight lspci
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
	PCIUTILS_DEPENDENCIES += busybox
endif

define PCIUTILS_CONFIGURE_CMDS
	$(SED) 's/wget --no-timestamping/wget/' $(PCIUTILS_DIR)/update-pciids.sh
	$(SED) 's/uname -s/echo Linux/' \
		-e 's/uname -r/echo $(LINUX_HEADERS_VERSION)/' \
		$(PCIUTILS_DIR)/lib/configure
	$(SED) 's/^STRIP/#STRIP/' $(PCIUTILS_DIR)/Makefile
endef

define PCIUTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(PCIUTILS_MAKE_OPTS) \
		PREFIX=/usr
endef

define PCIUTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) $(PCIUTILS_MAKE_OPTS) \
		PREFIX=$(TARGET_DIR)/usr install install-lib install-pcilib
endef

define PCIUTILS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) $(PCIUTILS_MAKE_OPTS) \
		PREFIX=$(STAGING_DIR)/usr install install-lib install-pcilib
endef

$(eval $(generic-package))
