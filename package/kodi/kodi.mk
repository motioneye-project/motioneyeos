################################################################################
#
# kodi
#
################################################################################

# When updating the version, please also update kodi-jsonschemabuilder
# and kodi-texturepacker
KODI_VERSION = 18.5-Leia
KODI_SITE = $(call github,xbmc,xbmc,$(KODI_VERSION))
KODI_LICENSE = GPL-2.0
KODI_LICENSE_FILES = LICENSE.md
# needed for binary addons
KODI_INSTALL_STAGING = YES
# kodi recommends building out-of-source
KODI_SUPPORTS_IN_SOURCE_BUILD = NO
KODI_DEPENDENCIES = \
	expat \
	flatbuffers \
	fmt \
	fontconfig \
	freetype \
	fstrcmp \
	gnutls \
	host-flatbuffers \
	host-gawk \
	host-gettext \
	host-gperf \
	host-kodi-jsonschemabuilder \
	host-kodi-texturepacker \
	host-nasm \
	host-swig \
	host-xmlstarlet \
	libass \
	libcdio \
	libcrossguid \
	libcurl \
	libfribidi \
	libplist \
	libsamplerate \
	lzo \
	ncurses \
	openssl \
	pcre \
	python \
	rapidjson \
	sqlite \
	taglib \
	tinyxml \
	zlib

# taken from tools/depends/target/*/*-VERSION
KODI_FFMPEG_VERSION = 4.0.4-Leia-18.4
KODI_LIBDVDCSS_VERSION = 1.4.2-Leia-Beta-5
KODI_LIBDVDNAV_VERSION = 6.0.0-Leia-Alpha-3
KODI_LIBDVDREAD_VERSION = 6.0.0-Leia-Alpha-3
KODI_EXTRA_DOWNLOADS += \
	$(call github,xbmc,FFmpeg,$(KODI_FFMPEG_VERSION))/kodi-ffmpeg-$(KODI_FFMPEG_VERSION).tar.gz \
	$(call github,xbmc,libdvdcss,$(KODI_LIBDVDCSS_VERSION))/kodi-libdvdcss-$(KODI_LIBDVDCSS_VERSION).tar.gz \
	$(call github,xbmc,libdvdnav,$(KODI_LIBDVDNAV_VERSION))/kodi-libdvdnav-$(KODI_LIBDVDNAV_VERSION).tar.gz \
	$(call github,xbmc,libdvdread,$(KODI_LIBDVDREAD_VERSION))/kodi-libdvdread-$(KODI_LIBDVDREAD_VERSION).tar.gz

define KODI_CPLUFF_AUTOCONF
	cd $(KODI_SRCDIR)/lib/cpluff && ./autogen.sh
endef
KODI_PRE_CONFIGURE_HOOKS += KODI_CPLUFF_AUTOCONF
KODI_DEPENDENCIES += host-automake host-autoconf host-libtool

KODI_CONF_OPTS += \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) $(KODI_C_FLAGS)" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) $(KODI_CXX_FLAGS)" \
	-DENABLE_APP_AUTONAME=OFF \
	-DENABLE_CCACHE=OFF \
	-DENABLE_DVDCSS=ON \
	-DENABLE_INTERNAL_CROSSGUID=OFF \
	-DENABLE_INTERNAL_FFMPEG=ON \
	-DENABLE_INTERNAL_FLATBUFFERS=OFF \
	-DFFMPEG_URL=$(KODI_DL_DIR)/kodi-ffmpeg-$(KODI_FFMPEG_VERSION).tar.gz \
	-DKODI_DEPENDSBUILD=OFF \
	-DENABLE_LDGOLD=OFF \
	-DNATIVEPREFIX=$(HOST_DIR) \
	-DDEPENDS_PATH=$(STAGING_DIR)/usr \
	-DWITH_JSONSCHEMABUILDER=$(HOST_DIR)/bin/JsonSchemaBuilder \
	-DWITH_TEXTUREPACKER=$(HOST_DIR)/bin/TexturePacker \
	-DLIBDVDCSS_URL=$(KODI_DL_DIR)/kodi-libdvdcss-$(KODI_LIBDVDCSS_VERSION).tar.gz \
	-DLIBDVDNAV_URL=$(KODI_DL_DIR)/kodi-libdvdnav-$(KODI_LIBDVDNAV_VERSION).tar.gz \
	-DLIBDVDREAD_URL=$(KODI_DL_DIR)/kodi-libdvdread-$(KODI_LIBDVDREAD_VERSION).tar.gz

ifeq ($(BR2_ENABLE_LOCALE),)
KODI_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_KODI_PLATFORM_RBPI),y)
# These CPU-specific options are only used on rbpi:
# https://github.com/xbmc/xbmc/blob/Krypton/project/cmake/scripts/rbpi/ArchSetup.cmake#L13
ifeq ($(BR2_arm1176jzf_s)$(BR2_cortex_a7)$(BR2_cortex_a53),y)
KODI_CONF_OPTS += -DWITH_CPU="$(GCC_TARGET_CPU)"
endif
else ifeq ($(BR2_arceb)$(BR2_arcle),y)
KODI_CONF_OPTS += -DWITH_ARCH=arc -DWITH_CPU=arc
else ifeq ($(BR2_armeb),y)
KODI_CONF_OPTS += -DWITH_ARCH=arm -DWITH_CPU=arm
else ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
KODI_CONF_OPTS += \
	-DWITH_ARCH=mips$(if $(BR2_ARCH_IS_64),64) \
	-DWITH_CPU=mips$(if $(BR2_ARCH_IS_64),64)
else ifeq ($(BR2_powerpc)$(BR2_powerpc64le),y)
KODI_CONF_OPTS += \
	-DWITH_ARCH=powerpc$(if $(BR2_ARCH_IS_64),64) \
	-DWITH_CPU=powerpc$(if $(BR2_ARCH_IS_64),64)
else ifeq ($(BR2_powerpc64)$(BR2_sparc64)$(BR2_sh4)$(BR2_xtensa),y)
KODI_CONF_OPTS += -DWITH_ARCH=$(BR2_ARCH) -DWITH_CPU=$(BR2_ARCH)
else
# Kodi auto-detects ARCH, tested: arm, aarch64, i386, x86_64
# see project/cmake/scripts/linux/ArchSetup.cmake
KODI_CONF_OPTS += -DWITH_CPU=$(BR2_ARCH)
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
KODI_CONF_OPTS += -D_SSE_OK=ON -D_SSE_TRUE=ON
else
KODI_CONF_OPTS += -D_SSE_OK=OFF -D_SSE_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
KODI_CONF_OPTS += -D_SSE2_OK=ON -D_SSE2_TRUE=ON
else
KODI_CONF_OPTS += -D_SSE2_OK=OFF -D_SSE2_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSE3),y)
KODI_CONF_OPTS += -D_SSE3_OK=ON -D_SSE3_TRUE=ON
else
KODI_CONF_OPTS += -D_SSE3_OK=OFF -D_SSE3_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSSE3),y)
KODI_CONF_OPTS += -D_SSSE3_OK=ON -D_SSSE3_TRUE=ON
else
KODI_CONF_OPTS += -D_SSSE3_OK=OFF -D_SSSE3_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSE4),y)
KODI_CONF_OPTS += -D_SSE41_OK=ON -D_SSE41_TRUE=ON
else
KODI_CONF_OPTS += -D_SSE41_OK=OFF -D_SSE41_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSE42),y)
KODI_CONF_OPTS += -D_SSE42_OK=ON -D_SSE42_TRUE=ON
else
KODI_CONF_OPTS += -D_SSE42_OK=OFF -D_SSE42_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_AVX),y)
KODI_CONF_OPTS += -D_AVX_OK=ON -D_AVX_TRUE=ON
else
KODI_CONF_OPTS += -D_AVX_OK=OFF -D_AVX_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_AVX2),y)
KODI_CONF_OPTS += -D_AVX2_OK=ON -D_AVX2_TRUE=ON
else
KODI_CONF_OPTS += -D_AVX2_OK=OFF -D_AVX2_TRUE=OFF
endif

# mips: uses __atomic_load_8
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
KODI_CXX_FLAGS += -latomic
endif

ifeq ($(BR2_PACKAGE_KODI_PLATFORM_RBPI),y)
KODI_CONF_OPTS += -DCORE_PLATFORM_NAME=rbpi
KODI_DEPENDENCIES += libinput libxkbcommon rpi-userland
endif

ifeq ($(BR2_PACKAGE_KODI_PLATFORM_WAYLAND_GL),y)
KODI_CONF_OPTS += \
	-DCORE_PLATFORM_NAME=wayland \
	-DWAYLAND_RENDER_SYSTEM=gl
KODI_DEPENDENCIES += libegl libgl libglu libxkbcommon waylandpp
endif

ifeq ($(BR2_PACKAGE_KODI_PLATFORM_WAYLAND_GLES),y)
KODI_CONF_OPTS += \
	-DCORE_PLATFORM_NAME=wayland \
	-DWAYLAND_RENDER_SYSTEM=gles
KODI_C_FLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags egl`
KODI_CXX_FLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags egl`
KODI_DEPENDENCIES += libegl libgles libxkbcommon waylandpp
endif

ifeq ($(BR2_PACKAGE_KODI_PLATFORM_X11_OPENGL),y)
KODI_CONF_OPTS += -DCORE_PLATFORM_NAME=x11
KODI_DEPENDENCIES += libegl libglu libgl xlib_libX11 xlib_libXext \
	xlib_libXrandr libdrm
endif

ifeq ($(BR2_PACKAGE_KODI_MYSQL),y)
KODI_CONF_OPTS += -DENABLE_MYSQLCLIENT=ON
KODI_DEPENDENCIES += mysql
else
KODI_CONF_OPTS += -DENABLE_MYSQLCLIENT=OFF
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
KODI_CONF_OPTS += -DENABLE_UDEV=ON
KODI_DEPENDENCIES += udev
else
KODI_CONF_OPTS += -DENABLE_UDEV=OFF
ifeq ($(BR2_PACKAGE_KODI_LIBUSB),y)
KODI_CONF_OPTS += -DENABLE_LIBUSB=ON
KODI_DEPENDENCIES += libusb-compat
endif
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
KODI_CONF_OPTS += -DENABLE_CAP=ON
KODI_DEPENDENCIES += libcap
else
KODI_CONF_OPTS += -DENABLE_CAP=OFF
endif

ifeq ($(BR2_PACKAGE_LIBXML2)$(BR2_PACKAGE_LIBXSLT),yy)
KODI_CONF_OPTS += -DENABLE_XSLT=ON
KODI_DEPENDENCIES += libxml2 libxslt
else
KODI_CONF_OPTS += -DENABLE_XSLT=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_BLUEZ),y)
KODI_CONF_OPTS += -DENABLE_BLUETOOTH=ON
KODI_DEPENDENCIES += bluez5_utils
else
KODI_CONF_OPTS += -DENABLE_BLUETOOTH=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_DBUS),y)
KODI_DEPENDENCIES += dbus
KODI_CONF_OPTS += -DENABLE_DBUS=ON
else
KODI_CONF_OPTS += -DENABLE_DBUS=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_EVENTCLIENTS),y)
KODI_CONF_OPTS += -DENABLE_EVENTCLIENTS=ON
else
KODI_CONF_OPTS += -DENABLE_EVENTCLIENTS=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_ALSA_LIB),y)
KODI_CONF_OPTS += -DENABLE_ALSA=ON
KODI_DEPENDENCIES += alsa-lib
else
KODI_CONF_OPTS += -DENABLE_ALSA=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_LIBMICROHTTPD),y)
KODI_CONF_OPTS += -DENABLE_MICROHTTPD=ON
KODI_DEPENDENCIES += libmicrohttpd
else
KODI_CONF_OPTS += -DENABLE_MICROHTTPD=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_LIBSMBCLIENT),y)
KODI_DEPENDENCIES += samba4
KODI_CONF_OPTS += -DENABLE_SMBCLIENT=ON
else
KODI_CONF_OPTS += -DENABLE_SMBCLIENT=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_LIBNFS),y)
KODI_DEPENDENCIES += libnfs
KODI_CONF_OPTS += -DENABLE_NFS=ON
else
KODI_CONF_OPTS += -DENABLE_NFS=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_LIBBLURAY),y)
KODI_DEPENDENCIES += libbluray
KODI_CONF_OPTS += -DENABLE_BLURAY=ON
else
KODI_CONF_OPTS += -DENABLE_BLURAY=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_LIBSHAIRPLAY),y)
KODI_DEPENDENCIES += libshairplay
KODI_CONF_OPTS += -DENABLE_AIRTUNES=ON
else
KODI_CONF_OPTS += -DENABLE_AIRTUNES=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_AVAHI),y)
KODI_DEPENDENCIES += avahi
KODI_CONF_OPTS += -DENABLE_AVAHI=ON
else
KODI_CONF_OPTS += -DENABLE_AVAHI=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_LIBCEC),y)
KODI_DEPENDENCIES += libcec
KODI_CONF_OPTS += -DENABLE_CEC=ON
else
KODI_CONF_OPTS += -DENABLE_CEC=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_LCMS2),y)
KODI_DEPENDENCIES += lcms2
KODI_CONF_OPTS += -DENABLE_LCMS2=ON
else
KODI_CONF_OPTS += -DENABLE_LCMS2=OFF
endif

ifeq ($(BR2_PACKAGE_LIRC_TOOLS),y)
KODI_DEPENDENCIES += lirc-tools
endif

ifeq ($(BR2_PACKAGE_KODI_LIBTHEORA),y)
KODI_DEPENDENCIES += libtheora
endif

# kodi needs libva & libva-glx
ifeq ($(BR2_PACKAGE_KODI_LIBVA)$(BR2_PACKAGE_MESA3D_DRI_DRIVER),yy)
KODI_DEPENDENCIES += mesa3d libva
KODI_CONF_OPTS += -DENABLE_VAAPI=ON
else
KODI_CONF_OPTS += -DENABLE_VAAPI=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_LIBVDPAU),y)
KODI_DEPENDENCIES += libvdpau
KODI_CONF_OPTS += -DENABLE_VDPAU=ON
else
KODI_CONF_OPTS += -DENABLE_VDPAU=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_UPNP),y)
KODI_CONF_OPTS += -DENABLE_UPNP=ON
else
KODI_CONF_OPTS += -DENABLE_UPNP=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_OPTICALDRIVE),y)
KODI_CONF_OPTS += -DENABLE_OPTICAL=ON
else
KODI_CONF_OPTS += -DENABLE_OPTICAL=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_PULSEAUDIO),y)
KODI_CONF_OPTS += -DENABLE_PULSEAUDIO=ON
KODI_DEPENDENCIES += pulseaudio
else
KODI_CONF_OPTS += -DENABLE_PULSEAUDIO=OFF
endif

# Remove versioncheck addon, updating Kodi is done by building a new
# buildroot image.
KODI_ADDON_MANIFEST = $(TARGET_DIR)/usr/share/kodi/system/addon-manifest.xml
define KODI_CLEAN_UNUSED_ADDONS
	rm -Rf $(TARGET_DIR)/usr/share/kodi/addons/service.xbmc.versioncheck
	$(HOST_DIR)/bin/xml ed -L \
		-d "/addons/addon[text()='service.xbmc.versioncheck']" \
		$(KODI_ADDON_MANIFEST)
endef
KODI_POST_INSTALL_TARGET_HOOKS += KODI_CLEAN_UNUSED_ADDONS

define KODI_INSTALL_BR_WRAPPER
	$(INSTALL) -D -m 0755 package/kodi/br-kodi \
		$(TARGET_DIR)/usr/bin/br-kodi
endef
KODI_POST_INSTALL_TARGET_HOOKS += KODI_INSTALL_BR_WRAPPER

# When run from a startup script, Kodi has no $HOME where to store its
# configuration, so ends up storing it in /.kodi  (yes, at the root of
# the rootfs). This is a problem for read-only filesystems. But we can't
# easily change that, so create /.kodi as a symlink where we want the
# config to eventually be. Add synlinks for the legacy XBMC name as well
define KODI_INSTALL_CONFIG_DIR
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/var/kodi
	ln -sf /var/kodi $(TARGET_DIR)/.kodi
	ln -sf /var/kodi $(TARGET_DIR)/var/xbmc
	ln -sf /var/kodi $(TARGET_DIR)/.xbmc
endef
KODI_POST_INSTALL_TARGET_HOOKS += KODI_INSTALL_CONFIG_DIR

define KODI_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/kodi/S50kodi \
		$(TARGET_DIR)/etc/init.d/S50kodi
endef

define KODI_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/kodi/kodi.service \
		$(TARGET_DIR)/usr/lib/systemd/system/kodi.service
endef

$(eval $(cmake-package))
