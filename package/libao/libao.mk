################################################################################
#
# libao
#
################################################################################

LIBAO_VERSION = 1.2.0
LIBAO_SITE = http://downloads.xiph.org/releases/ao
LIBAO_DEPENDENCIES = host-pkgconf
LIBAO_INSTALL_STAGING = YES
LIBAO_LICENSE = GPLv2+
LIBAO_LICENSE_FILES = COPYING
LIBAO_CONF_OPTS = --disable-esd --disable-wmm --disable-arts \
			--disable-nas --disable-pulse --disable-broken-oss

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
LIBAO_DEPENDENCIES += alsa-lib
LIBAO_CONF_OPTS += --enable-alsa --enable-alsa-mmap

# Remove the OSS plugin if ALSA is enabled, as libao will prefer ALSA anyway
define LIBAO_REMOVE_OSS_PLUGIN
	rm -f $(TARGET_DIR)/usr/lib/ao/plugins-4/liboss.so
endef
LIBAO_POST_INSTALL_TARGET_HOOKS += LIBAO_REMOVE_OSS_PLUGIN
else
LIBAO_CONF_OPTS += --disable-alsa
endif

$(eval $(autotools-package))
