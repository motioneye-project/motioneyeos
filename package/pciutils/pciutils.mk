#############################################################
#
# PCIUTILS
#
#############################################################

PCIUTILS_VERSION = 3.1.7
PCIUTILS_SITE = ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci
ifeq ($(BR2_PACKAGE_ZLIB),y)
	PCIUTILS_ZLIB=yes
else
	PCIUTILS_ZLIB=no
endif
PCIUTILS_DNS=no
PCIUTILS_SHARED=yes

define PCIUTILS_CONFIGURE_CMDS
	$(SED) 's/uname -s/echo Linux/' \
		-e 's/uname -r/echo $(LINUX_HEADERS_VERSION)/' \
		$(PCIUTILS_DIR)/lib/configure
endef

define PCIUTILS_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" \
		OPT="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		RANLIB=$(TARGET_RANLIB) \
		AR=$(TARGET_AR) \
		-C $(PCIUTILS_DIR) \
		SHARED=$(PCIUTILS_SHARED) \
		ZLIB=$(PCIUTILS_ZLIB) \
		DNS=$(PCIUTILS_DNS) \
		SHAREDIR=/usr/share/misc
endef

define PCIUTILS_INSTALL_TARGET_CMDS
	$(MAKE) BUILDDIR=$(@D) -C $(@D) PREFIX=$(TARGET_DIR)/usr install
endef

$(eval $(call GENTARGETS,package,pciutils))
