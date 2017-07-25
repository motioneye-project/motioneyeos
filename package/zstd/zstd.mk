################################################################################
#
# zstd
#
################################################################################

ZSTD_VERSION = v1.3.0
ZSTD_SITE = $(call github,facebook,zstd,$(ZSTD_VERSION))
ZSTD_LICENSE = BSD-3-Clause
ZSTD_LICENSE_FILES = LICENSE PATENTS

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
ZSTD_OPTS += HAVE_THREAD=1
else
ZSTD_OPTS += HAVE_THREAD=0
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
ZSTD_DEPENDENCIES += zlib
ZSTD_OPTS += HAVE_ZLIB=1
else
ZSTD_OPTS += HAVE_ZLIB=0
endif

ifeq ($(BR2_PACKAGE_XZ),y)
ZSTD_DEPENDENCIES += xz
ZSTD_OPTS += HAVE_LZMA=1
else
ZSTD_OPTS += HAVE_LZMA=0
endif

ifeq ($(BR2_PACKAGE_LZ4),y)
ZSTD_DEPENDENCIES += lz4
ZSTD_OPTS += HAVE_LZ4=1
else
ZSTD_OPTS += HAVE_LZ4=0
endif

define ZSTD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(ZSTD_OPTS) \
		-C $(@D) zstd
endef

define ZSTD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(ZSTD_OPTS) \
		DESTDIR=$(TARGET_DIR) -C $(@D)/programs install
endef

$(eval $(generic-package))
