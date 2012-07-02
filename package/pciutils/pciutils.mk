#############################################################
#
# PCIUTILS
#
#############################################################

PCIUTILS_VERSION = 3.1.10
PCIUTILS_SITE = ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci
PCIUTILS_INSTALL_STAGING = YES
ifeq ($(BR2_PACKAGE_ZLIB),y)
	PCIUTILS_ZLIB=yes
	PCIUTILS_DEPENDENCIES += zlib
else
	PCIUTILS_ZLIB=no
endif
PCIUTILS_DNS=no
PCIUTILS_SHARED=yes

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
	$(MAKE) CC="$(TARGET_CC)" \
		HOST="$(KERNEL_ARCH)-linux" \
		OPT="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		RANLIB=$(TARGET_RANLIB) \
		AR=$(TARGET_AR) \
		-C $(PCIUTILS_DIR) \
		SHARED=$(PCIUTILS_SHARED) \
		ZLIB=$(PCIUTILS_ZLIB) \
		DNS=$(PCIUTILS_DNS) \
		PREFIX=/usr
endef

# Ditch install-lib if SHARED is an option in the future
define PCIUTILS_INSTALL_TARGET_CMDS
	$(MAKE) BUILDDIR=$(@D) -C $(@D) PREFIX=$(TARGET_DIR)/usr \
		SHARED=$(PCIUTILS_SHARED) install install-lib
endef

define PCIUTILS_INSTALL_STAGING_CMDS
	$(MAKE) BUILDDIR=$(@D) -C $(@D) PREFIX=$(STAGING_DIR)/usr \
		SHARED=$(PCIUTILS_SHARED) install install-lib
endef

$(eval $(generic-package))
