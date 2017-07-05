################################################################################
#
# kodi
#
################################################################################

# When updating the version, please also update kodi-jsonschemabuilder
# and kodi-texturepacker
KODI_VERSION = 17.3-Krypton
KODI_SITE = $(call github,xbmc,xbmc,$(KODI_VERSION))
KODI_LICENSE = GPL-2.0
KODI_LICENSE_FILES = LICENSE.GPL
# needed for binary addons
KODI_INSTALL_STAGING = YES
KODI_DEPENDENCIES = \
	bzip2 \
	expat \
	ffmpeg \
	fontconfig \
	freetype \
	host-gawk \
	host-gperf \
	host-kodi-jsonschemabuilder \
	host-kodi-texturepacker \
	host-nasm \
	host-swig \
	host-xmlstarlet \
	host-zip \
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
	readline \
	sqlite \
	taglib \
	tinyxml \
	yajl \
	zlib

KODI_SUBDIR = project/cmake

KODI_LIBDVDCSS_VERSION = 2f12236
KODI_LIBDVDNAV_VERSION = 981488f
KODI_LIBDVDREAD_VERSION = 17d99db

KODI_EXTRA_DOWNLOADS = \
	https://github.com/xbmc/libdvdcss/archive/$(KODI_LIBDVDCSS_VERSION).tar.gz \
	https://github.com/xbmc/libdvdnav/archive/$(KODI_LIBDVDNAV_VERSION).tar.gz \
	https://github.com/xbmc/libdvdread/archive/$(KODI_LIBDVDREAD_VERSION).tar.gz

KODI_CONF_OPTS += \
	-DENABLE_CCACHE=OFF \
	-DENABLE_DVDCSS=ON \
	-DENABLE_INTERNAL_CROSSGUID=OFF \
	-DENABLE_INTERNAL_FFMPEG=OFF \
	-DKODI_DEPENDSBUILD=OFF \
	-DENABLE_OPENSSL=ON \
	-DNATIVEPREFIX=$(HOST_DIR) \
	-DDEPENDS_PATH=$(@D) \
	-DWITH_TEXTUREPACKER=$(HOST_DIR)/bin/TexturePacker \
	-DLIBDVDCSS_URL=$(DL_DIR)/$(KODI_LIBDVDCSS_VERSION).tar.gz \
	-DLIBDVDNAV_URL=$(DL_DIR)/$(KODI_LIBDVDNAV_VERSION).tar.gz \
	-DLIBDVDREAD_URL=$(DL_DIR)/$(KODI_LIBDVDREAD_VERSION).tar.gz

ifeq ($(BR2_arm),y)
KODI_CONF_OPTS += -DWITH_ARCH=arm -DWITH_CPU=arm
else ifeq ($(BR2_mips),y)
KODI_CONF_OPTS += -DWITH_ARCH=mips -DWITH_CPU=mips
else ifeq ($(BR2_i386),y)
KODI_CONF_OPTS += -DWITH_ARCH=i486-linux -DWITH_CPU=$(BR2_GCC_TARGET_ARCH)
else ifeq ($(BR2_x86_64),y)
KODI_CONF_OPTS += -DWITH_ARCH=x86_64-linux -DWITH_CPU=x86_64
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

ifeq ($(BR2_PACKAGE_KODI_MYSQL),y)
KODI_CONF_OPTS += -DENABLE_MYSQLCLIENT=ON
KODI_DEPENDENCIES += mysql
else
KODI_CONF_OPTS += -DENABLE_MYSQLCLIENT=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_NONFREE),y)
KODI_CONF_OPTS += -DENABLE_NONFREE=ON
KODI_LICENSE := $(KODI_LICENSE), unrar
KODI_LICENSE_FILES += lib/UnrarXLib/license.txt
else
KODI_CONF_OPTS += -DENABLE_NONFREE=OFF
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
KODI_CONF_OPTS += -DCORE_SYSTEM_NAME=rbpi
KODI_DEPENDENCIES += rpi-userland
else
# Kodi considers "rpbi" and "linux" as two separate platforms. The
# below options, defined in
# project/cmake/scripts/linux/ArchSetup.cmake are only valid for the
# "linux" platforms. The "rpbi" platform has a different set of
# options, defined in project/cmake/scripts/rbpi/
KODI_CONF_OPTS += -DENABLE_LDGOLD=OFF
ifeq ($(BR2_PACKAGE_LIBAMCODEC),y)
KODI_CONF_OPTS += -DENABLE_AML=ON
KODI_DEPENDENCIES += libamcodec
else
KODI_CONF_OPTS += -DENABLE_AML=OFF
endif
ifeq ($(BR2_PACKAGE_IMX_VPUWRAP),y)
KODI_CONF_OPTS += -DENABLE_IMX=ON
KODI_DEPENDENCIES += imx-vpuwrap
else
KODI_CONF_OPTS += -DENABLE_IMX=OFF
endif
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

ifeq ($(BR2_PACKAGE_KODI_GL_EGL),y)
KODI_DEPENDENCIES += libegl libglu libgl xlib_libX11 xlib_libXext \
	xlib_libXrandr libdrm
KODI_CONF_OPTS += -DENABLE_OPENGL=ON -DENABLE_X11=ON -DENABLE_OPENGLES=OFF
else
KODI_CONF_OPTS += -DENABLE_OPENGL=OFF -DENABLE_X11=OFF
endif

ifeq ($(BR2_PACKAGE_KODI_EGL_GLES),y)
KODI_DEPENDENCIES += libegl libgles
KODI_CONF_OPTS += \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) `$(PKG_CONFIG_HOST_BINARY) --cflags --libs egl`" \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) `$(PKG_CONFIG_HOST_BINARY) --cflags --libs egl`" \
	-DENABLE_OPENGLES=ON
else
KODI_CONF_OPTS += -DENABLE_OPENGLES=OFF
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

ifeq ($(BR2_PACKAGE_KODI_LIBSSH),y)
KODI_DEPENDENCIES += libssh
KODI_CONF_OPTS += -DENABLE_SSH=ON
else
KODI_CONF_OPTS += -DENABLE_SSH=OFF
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

ifeq ($(BR2_PACKAGE_KODI_LIRC),y)
KODI_CONF_OPTS += -DENABLE_LIRC=ON
else
KODI_CONF_OPTS += -DENABLE_LIRC=OFF
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

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -fs ../../../../usr/lib/systemd/system/kodi.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/kodi.service
endef

$(eval $(cmake-package))
