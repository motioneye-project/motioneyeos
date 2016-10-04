################################################################################
#
# pciutils
#
################################################################################

PCIUTILS_VERSION = 3.5.2
PCIUTILS_SITE = $(BR2_KERNEL_MIRROR)/software/utils/pciutils
PCIUTILS_SOURCE = pciutils-$(PCIUTILS_VERSION).tar.xz
PCIUTILS_INSTALL_STAGING = YES
PCIUTILS_LICENSE = GPLv2+
PCIUTILS_LICENSE_FILES = COPYING
PCIUTILS_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	HOST="$(KERNEL_ARCH)-linux" \
	OPT="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	RANLIB=$(TARGET_RANLIB) \
	AR=$(TARGET_AR) \
	DNS=no

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
PCIUTILS_DEPENDENCIES += udev
PCIUTILS_MAKE_OPTS += HWDB=yes
else
PCIUTILS_MAKE_OPTS += HWDB=no
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
PCIUTILS_MAKE_OPTS += ZLIB=yes
PCIUTILS_DEPENDENCIES += zlib
else
PCIUTILS_MAKE_OPTS += ZLIB=no
endif

ifeq ($(BR2_PACKAGE_KMOD),y)
PCIUTILS_DEPENDENCIES += kmod
PCIUTILS_MAKE_OPTS += LIBKMOD=yes
else
PCIUTILS_MAKE_OPTS += LIBKMOD=no
endif

ifeq ($(BR2_STATIC_LIBS),y)
PCIUTILS_MAKE_OPTS += SHARED=no
else
PCIUTILS_MAKE_OPTS += SHARED=yes
endif

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
		PREFIX=$(TARGET_DIR)/usr SBINDIR=$(TARGET_DIR)/usr/bin \
		install install-lib install-pcilib
endef

define PCIUTILS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) $(PCIUTILS_MAKE_OPTS) \
		PREFIX=$(STAGING_DIR)/usr SBINDIR=$(STAGING_DIR)/usr/bin \
		install install-lib install-pcilib
endef

$(eval $(generic-package))
