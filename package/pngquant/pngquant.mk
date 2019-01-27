################################################################################
#
# pngquant
#
################################################################################

PNGQUANT_VERSION = 2.12.2
PNGQUANT_SOURCE = pngquant-$(PNGQUANT_VERSION)-src.tar.gz
PNGQUANT_SITE = https://pngquant.org
PNGQUANT_LICENSE = GPL-3.0+
PNGQUANT_LICENSE_FILES = COPYRIGHT
HOST_PNGQUANT_DEPENDENCIES = host-libpng
PNGQUANT_DEPENDENCIES = libpng

ifeq ($(BR2_PACKAGE_LCMS2),y)
PNGQUANT_DEPENDENCIES += lcms2
endif

define PNGQUANT_CONFIGURE_CMDS
	(cd $(@D) && \
		$(TARGET_CONFIGURE_OPTS) \
		./configure --prefix=/usr \
		$(if $(BR2_PACKAGE_LCMS2),--with-lcms2,--without-lcms2) \
		$(if $(BR2_X86_CPU_HAS_SSE),--enable-sse,--disable-sse) \
		$(TARGET_CONFIGURE_OPTS) \
	)
endef

define PNGQUANT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define PNGQUANT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR="$(TARGET_DIR)" -C $(@D) install
endef

define HOST_PNGQUANT_CONFIGURE_CMDS
	(cd $(@D) && \
		$(HOST_CONFIGURE_OPTS) \
		CC=$(HOSTCC_NOCCACHE) \
		./configure --prefix=$(HOST_DIR) \
		--without-lcms2 \
	)
endef

define HOST_PNGQUANT_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_PNGQUANT_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
