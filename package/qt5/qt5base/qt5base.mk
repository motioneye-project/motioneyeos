################################################################################
#
# qt5base
#
################################################################################

QT5BASE_VERSION = $(QT5_VERSION)
QT5BASE_SITE = $(QT5_SITE)
QT5BASE_SOURCE = qtbase-opensource-src-$(QT5BASE_VERSION).tar.xz

QT5BASE_DEPENDENCIES = host-pkgconf zlib
QT5BASE_INSTALL_STAGING = YES

# A few comments:
#  * -no-pch to workaround the issue described at
#     http://comments.gmane.org/gmane.comp.lib.qt.devel/5933.
#  * -system-zlib because zlib is mandatory for Qt build, and we
#     want to use the Buildroot packaged zlib
#  * -system-pcre because pcre is mandatory to build Qt, and we
#    want to use the one packaged in Buildroot
QT5BASE_CONFIGURE_OPTS += \
	-optimized-qmake \
	-no-cups \
	-no-iconv \
	-system-zlib \
	-system-pcre \
	-no-pch \
	-shared

ifeq ($(BR2_PACKAGE_QT5_VERSION_5_6),y)
QT5BASE_DEPENDENCIES += pcre
else
QT5BASE_DEPENDENCIES += pcre2
endif

QT5BASE_CONFIGURE_OPTS += $(call qstrip,$(BR2_PACKAGE_QT5BASE_CUSTOM_CONF_OPTS))

# Uses libgbm from mesa3d
ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
QT5BASE_CONFIGURE_OPTS += -kms -gbm
QT5BASE_DEPENDENCIES += mesa3d
else
QT5BASE_CONFIGURE_OPTS += -no-kms
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
QT5BASE_CONFIGURE_OPTS += -debug
else
QT5BASE_CONFIGURE_OPTS += -release
endif

ifeq ($(BR2_PACKAGE_QT5_VERSION_5_6),y)
QT5BASE_CONFIGURE_OPTS += -largefile
endif

QT5BASE_CONFIGURE_OPTS += -opensource -confirm-license
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5BASE_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5BASE_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPLv3 LICENSE.GPL3-EXCEPT LICENSE.LGPLv3 LICENSE.FDL
else
QT5BASE_LICENSE = GPL-3.0 or LGPL-2.1 with exception or LGPL-3.0, GFDL-1.3 (docs)
QT5BASE_LICENSE_FILES = LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL
endif
ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
QT5BASE_LICENSE := $(QT5BASE_LICENSE), BSD-3-Clause (examples)
QT5BASE_LICENSE_FILES += header.BSD
endif

QT5BASE_CONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_QT5BASE_CONFIG_FILE))

ifneq ($(QT5BASE_CONFIG_FILE),)
QT5BASE_CONFIGURE_OPTS += -qconfig buildroot
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
QT5BASE_DEPENDENCIES += udev
endif

# Qt5 SQL Plugins
ifeq ($(BR2_PACKAGE_QT5BASE_SQL),y)
ifeq ($(BR2_PACKAGE_QT5BASE_MYSQL),y)
QT5BASE_CONFIGURE_OPTS += -plugin-sql-mysql -mysql_config $(STAGING_DIR)/usr/bin/mysql_config
QT5BASE_DEPENDENCIES   += mysql
else
QT5BASE_CONFIGURE_OPTS += -no-sql-mysql
endif

ifeq ($(BR2_PACKAGE_QT5BASE_PSQL),y)
QT5BASE_CONFIGURE_OPTS += -plugin-sql-psql -psql_config $(STAGING_DIR)/usr/bin/pg_config
QT5BASE_DEPENDENCIES   += postgresql
else
QT5BASE_CONFIGURE_OPTS += -no-sql-psql
endif

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_SQLITE_QT),-plugin-sql-sqlite)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_SQLITE_SYSTEM),-system-sqlite)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_SQLITE_SYSTEM),sqlite)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_SQLITE_NONE),-no-sql-sqlite)
endif

ifeq ($(BR2_PACKAGE_QT5BASE_GUI),y)
QT5BASE_CONFIGURE_OPTS += -gui -system-freetype
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5_VERSION_5_6),-I$(STAGING_DIR)/usr/include/freetype2)
QT5BASE_DEPENDENCIES += freetype
else
QT5BASE_CONFIGURE_OPTS += -no-gui -no-freetype
endif

ifeq ($(BR2_PACKAGE_QT5BASE_HARFBUZZ),y)
ifeq ($(BR2_TOOLCHAIN_HAS_SYNC_4),y)
# system harfbuzz in case __sync for 4 bytes is supported
QT5BASE_CONFIGURE_OPTS += -system-harfbuzz
QT5BASE_DEPENDENCIES += harfbuzz
else
# qt harfbuzz otherwise (using QAtomic instead)
QT5BASE_CONFIGURE_OPTS += -qt-harfbuzz
QT5BASE_LICENSE := $(QT5BASE_LICENSE), MIT (harfbuzz)
QT5BASE_LICENSE_FILES += src/3rdparty/harfbuzz-ng/COPYING
endif
else
QT5BASE_CONFIGURE_OPTS += -no-harfbuzz
endif

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_WIDGETS),-widgets,-no-widgets)
# We have to use --enable-linuxfb, otherwise Qt thinks that -linuxfb
# is to add a link against the "inuxfb" library.
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_LINUXFB),--enable-linuxfb,-no-linuxfb)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_DIRECTFB),-directfb,-no-directfb)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_DIRECTFB),directfb)

ifeq ($(BR2_PACKAGE_QT5BASE_XCB),y)
QT5BASE_CONFIGURE_OPTS += -xcb -system-xkbcommon
QT5BASE_DEPENDENCIES   += \
	libxcb \
	xcb-util-wm \
	xcb-util-image \
	xcb-util-keysyms \
	xlib_libX11 \
	libxkbcommon
ifeq ($(BR2_PACKAGE_QT5BASE_WIDGETS),y)
QT5BASE_DEPENDENCIES   += xlib_libXext
endif
else
QT5BASE_CONFIGURE_OPTS += -no-xcb
endif

ifeq ($(BR2_PACKAGE_QT5BASE_OPENGL_DESKTOP),y)
QT5BASE_CONFIGURE_OPTS += -opengl desktop
QT5BASE_DEPENDENCIES   += libgl
else ifeq ($(BR2_PACKAGE_QT5BASE_OPENGL_ES2),y)
QT5BASE_CONFIGURE_OPTS += -opengl es2
QT5BASE_DEPENDENCIES   += libgles
else
QT5BASE_CONFIGURE_OPTS += -no-opengl
endif

QT5BASE_DEFAULT_QPA = $(call qstrip,$(BR2_PACKAGE_QT5BASE_DEFAULT_QPA))
QT5BASE_CONFIGURE_OPTS += $(if $(QT5BASE_DEFAULT_QPA),-qpa $(QT5BASE_DEFAULT_QPA))

ifeq ($(BR2_PACKAGE_QT5BASE_EGLFS),y)
QT5BASE_CONFIGURE_OPTS += -eglfs
QT5BASE_DEPENDENCIES   += libegl
else
QT5BASE_CONFIGURE_OPTS += -no-eglfs
endif

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_OPENSSL),-openssl,-no-openssl)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_OPENSSL),openssl)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_FONTCONFIG),-fontconfig,-no-fontconfig)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_FONTCONFIG),fontconfig)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_GIF),,-no-gif)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_JPEG),-system-libjpeg,-no-libjpeg)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_JPEG),jpeg)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_PNG),-system-libpng,-no-libpng)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_PNG),libpng)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_DBUS),-dbus,-no-dbus)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_DBUS),dbus)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_TSLIB),-tslib,-no-tslib)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_TSLIB),tslib)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_LIBGLIB2),-glib,-no-glib)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_LIBGLIB2),libglib2)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_ICU),-icu,-no-icu)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_ICU),icu)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_EXAMPLES),-make,-nomake) examples

ifeq ($(BR2_PACKAGE_QT5_VERSION_5_6),y)
# gstreamer 0.10 support is broken in qt5multimedia
ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE),y)
QT5BASE_CONFIGURE_OPTS += -gstreamer 1.0
QT5BASE_DEPENDENCIES   += gst1-plugins-base
else
QT5BASE_CONFIGURE_OPTS += -no-gstreamer
endif
endif

ifeq ($(BR2_PACKAGE_LIBINPUT),y)
QT5BASE_CONFIGURE_OPTS += -libinput
QT5BASE_DEPENDENCIES += libinput
else
QT5BASE_CONFIGURE_OPTS += -no-libinput
endif

ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
# only enable gtk support if libgtk3 X11 backend is enabled
ifeq ($(BR2_PACKAGE_LIBGTK3)$(BR2_PACKAGE_LIBGTK3_X11),yy)
QT5BASE_CONFIGURE_OPTS += -gtk
QT5BASE_DEPENDENCIES += libgtk3
else
QT5BASE_CONFIGURE_OPTS += -no-gtk
endif
endif

# Build the list of libraries to be installed on the target
QT5BASE_INSTALL_LIBS_y                                 += Qt5Core
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_XCB)        += Qt5XcbQpa
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_NETWORK)    += Qt5Network
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_CONCURRENT) += Qt5Concurrent
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_SQL)        += Qt5Sql
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_TEST)       += Qt5Test
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_XML)        += Qt5Xml
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_OPENGL_LIB) += Qt5OpenGL
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_EGLFS)      += Qt5EglFSDeviceIntegration
ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_EGLFS)      += Qt5EglFsKmsSupport
endif
else
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_EGLFS)      += Qt5EglDeviceIntegration
endif

QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_GUI)          += Qt5Gui
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_WIDGETS)      += Qt5Widgets
QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_PRINTSUPPORT) += Qt5PrintSupport

QT5BASE_INSTALL_LIBS_$(BR2_PACKAGE_QT5BASE_DBUS) += Qt5DBus

ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST)$(BR2_PACKAGE_IMX_GPU_VIV),yy)
# use vivante backend
QT5BASE_EGLFS_DEVICE = EGLFS_DEVICE_INTEGRATION = eglfs_viv
endif

ifneq ($(QT5BASE_CONFIG_FILE),)
define QT5BASE_CONFIGURE_CONFIG_FILE
	cp $(QT5BASE_CONFIG_FILE) $(@D)/src/corelib/global/qconfig-buildroot.h
endef
endif

QT5BASE_ARCH_CONFIG_FILE = $(@D)/mkspecs/devices/linux-buildroot-g++/arch.conf
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC)$(BR2_PACKAGE_QT5_VERSION_LATEST),yy)
# Qt 5.8 needs atomics, which on various architectures are in -latomic
define QT5BASE_CONFIGURE_ARCH_CONFIG
	printf 'LIBS += -latomic\n' >$(QT5BASE_ARCH_CONFIG_FILE)
endef
endif

define QT5BASE_CONFIGURE_CMDS
	mkdir -p $(@D)/mkspecs/devices/linux-buildroot-g++/
	sed 's/@EGLFS_DEVICE@/$(QT5BASE_EGLFS_DEVICE)/g' \
		$(QT5BASE_PKGDIR)/qmake.conf.in > \
		$(@D)/mkspecs/devices/linux-buildroot-g++/qmake.conf
	$(INSTALL) -m 0644 -D $(QT5BASE_PKGDIR)/qplatformdefs.h \
		$(@D)/mkspecs/devices/linux-buildroot-g++/qplatformdefs.h
	$(QT5BASE_CONFIGURE_CONFIG_FILE)
	touch $(QT5BASE_ARCH_CONFIG_FILE)
	$(QT5BASE_CONFIGURE_ARCH_CONFIG)
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
		PKG_CONFIG_LIBDIR="$(STAGING_DIR)/usr/lib/pkgconfig" \
		PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)" \
		MAKEFLAGS="$(MAKEFLAGS) -j$(PARALLEL_JOBS)" \
		./configure \
		-v \
		-prefix /usr \
		-hostprefix $(HOST_DIR) \
		-headerdir /usr/include/qt5 \
		-sysroot $(STAGING_DIR) \
		-plugindir /usr/lib/qt/plugins \
		-examplesdir /usr/lib/qt/examples \
		-no-rpath \
		-nomake tests \
		-device buildroot \
		-device-option CROSS_COMPILE="$(TARGET_CROSS)" \
		-device-option BR_COMPILER_CFLAGS="$(TARGET_CFLAGS) $(QT5BASE_EXTRA_CFLAGS)" \
		-device-option BR_COMPILER_CXXFLAGS="$(TARGET_CXXFLAGS) $(QT5BASE_EXTRA_CFLAGS)" \
		$(QT5BASE_CONFIGURE_OPTS) \
	)
endef

define QT5BASE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

# The file "qt.conf" can be used to override the hard-coded paths that are
# compiled into the Qt library. We need it to make "qmake" relocatable.
define QT5BASE_INSTALL_QT_CONF
	sed -e "s|@@HOST_DIR@@|$(HOST_DIR)|" -e "s|@@STAGING_DIR@@|$(STAGING_DIR)|" \
		$(QT5BASE_PKGDIR)/qt.conf.in > $(HOST_DIR)/bin/qt.conf
endef

define QT5BASE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
	$(QT5BASE_INSTALL_QT_CONF)
endef

define QT5BASE_INSTALL_TARGET_LIBS
	for lib in $(QT5BASE_INSTALL_LIBS_y); do \
		cp -dpf $(STAGING_DIR)/usr/lib/lib$${lib}.so.* $(TARGET_DIR)/usr/lib || exit 1 ; \
	done
endef

define QT5BASE_INSTALL_TARGET_PLUGINS
	if [ -d $(STAGING_DIR)/usr/lib/qt/plugins/ ] ; then \
		mkdir -p $(TARGET_DIR)/usr/lib/qt/plugins ; \
		cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/* $(TARGET_DIR)/usr/lib/qt/plugins ; \
	fi
endef

ifeq ($(BR2_PACKAGE_QT5_VERSION_5_6),y)
define QT5BASE_INSTALL_TARGET_FONTS
	if [ -d $(STAGING_DIR)/usr/lib/fonts/ ] ; then \
		mkdir -p $(TARGET_DIR)/usr/lib/fonts ; \
		cp -dpfr $(STAGING_DIR)/usr/lib/fonts/* $(TARGET_DIR)/usr/lib/fonts ; \
	fi
endef
endif

define QT5BASE_INSTALL_TARGET_EXAMPLES
	if [ -d $(STAGING_DIR)/usr/lib/qt/examples/ ] ; then \
		mkdir -p $(TARGET_DIR)/usr/lib/qt/examples ; \
		cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/* $(TARGET_DIR)/usr/lib/qt/examples ; \
	fi
endef

ifeq ($(BR2_STATIC_LIBS),y)
define QT5BASE_INSTALL_TARGET_CMDS
	$(QT5BASE_INSTALL_TARGET_FONTS)
	$(QT5BASE_INSTALL_TARGET_EXAMPLES)
endef
else
define QT5BASE_INSTALL_TARGET_CMDS
	$(QT5BASE_INSTALL_TARGET_LIBS)
	$(QT5BASE_INSTALL_TARGET_PLUGINS)
	$(QT5BASE_INSTALL_TARGET_FONTS)
	$(QT5BASE_INSTALL_TARGET_EXAMPLES)
endef
endif

$(eval $(generic-package))
