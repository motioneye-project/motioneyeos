################################################################################
#
# Qt Embedded for Linux
#
# This makefile was originally composed by Thomas Lundquist <thomasez@zelow.no>
# Later heavily modified by buildroot developers
#
# BTW, this uses alot of FPU calls and it's pretty slow if you use
# the kernels FPU emulation so it's better to choose soft float in the
# buildroot config (and uClibc.config of course, if you have your own.)
#
################################################################################

QT_VERSION_MAJOR = 4.8
QT_VERSION = $(QT_VERSION_MAJOR).7
QT_SOURCE = qt-everywhere-opensource-src-$(QT_VERSION).tar.gz
QT_SITE = http://download.qt-project.org/official_releases/qt/$(QT_VERSION_MAJOR)/$(QT_VERSION)
# Patch fixing ALSA detection. Taken from Qt5, but applies fine to
# Qt4.
QT_PATCH = https://github.com/qtproject/qtbase/commit/b8f98d956501dfa4ce03a137f15d404930a56066.patch
QT_DEPENDENCIES = host-pkgconf
QT_INSTALL_STAGING = YES

QT_LICENSE := LGPL-2.1 with exceptions or GPL-3.0
ifneq ($(BR2_PACKAGE_QT_LICENSE_APPROVED),y)
QT_LICENSE := $(QT_LICENSE) or Digia Qt Commercial license
endif
QT_LICENSE_FILES = LICENSE.LGPL LGPL_EXCEPTION.txt LICENSE.GPL3

ifeq ($(BR2_PACKAGE_QT_LICENSE_APPROVED),y)
QT_CONFIGURE_OPTS += -opensource -confirm-license
endif

QT_CONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_QT_CONFIG_FILE))

ifneq ($(QT_CONFIG_FILE),)
QT_CONFIGURE_OPTS += -qconfig buildroot
endif

QT_CFLAGS = $(TARGET_CFLAGS)
QT_CXXFLAGS = $(TARGET_CXXFLAGS)
QT_LDFLAGS = $(TARGET_LDFLAGS)

# Qt WebKit build fails when gcc-6 is used for build, because
# 'std::auto_ptr' is deprecated starting from gcc 6.x. So, we have to
# use an older c++ standard to prevent build failure
QT_CXXFLAGS += -std=gnu++98

# Qt has some assembly function that are not present in thumb1 mode:
# Error: selected processor does not support Thumb mode `swp r3,r7,[r4]'
# so, we desactivate thumb mode
ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB),y)
QT_CFLAGS += -marm
QT_CXXFLAGS += -marm
endif

ifeq ($(BR2_PACKAGE_QT_QT3SUPPORT),y)
QT_CONFIGURE_OPTS += -qt3support
else
QT_CONFIGURE_OPTS += -no-qt3support
endif

ifeq ($(BR2_PACKAGE_QT_DEMOS),y)
QT_CONFIGURE_OPTS += -demosdir $(TARGET_DIR)/usr/share/qt/demos
else
QT_CONFIGURE_OPTS += -nomake demos
endif
ifeq ($(BR2_PACKAGE_QT_EXAMPLES),y)
QT_CONFIGURE_OPTS += -examplesdir $(TARGET_DIR)/usr/share/qt/examples
else
QT_CONFIGURE_OPTS += -nomake examples
endif

# ensure glib is built first if enabled for Qt's glib support
ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
QT_CONFIGURE_OPTS += -glib
QT_DEPENDENCIES += libglib2
else
QT_CONFIGURE_OPTS += -no-glib
endif

### Pixel depths
QT_PIXEL_DEPTHS = # empty
ifeq ($(BR2_PACKAGE_QT_PIXEL_DEPTH_1),y)
QT_PIXEL_DEPTHS += 1
endif
ifeq ($(BR2_PACKAGE_QT_PIXEL_DEPTH_4),y)
QT_PIXEL_DEPTHS += 4
endif
ifeq ($(BR2_PACKAGE_QT_PIXEL_DEPTH_8),y)
QT_PIXEL_DEPTHS += 8
endif
ifeq ($(BR2_PACKAGE_QT_PIXEL_DEPTH_12),y)
QT_PIXEL_DEPTHS += 12
endif
ifeq ($(BR2_PACKAGE_QT_PIXEL_DEPTH_15),y)
QT_PIXEL_DEPTHS += 15
endif
ifeq ($(BR2_PACKAGE_QT_PIXEL_DEPTH_16),y)
QT_PIXEL_DEPTHS += 16
endif
ifeq ($(BR2_PACKAGE_QT_PIXEL_DEPTH_18),y)
QT_PIXEL_DEPTHS += 18
endif
ifeq ($(BR2_PACKAGE_QT_PIXEL_DEPTH_24),y)
QT_PIXEL_DEPTHS += 24
endif
ifeq ($(BR2_PACKAGE_QT_PIXEL_DEPTH_32),y)
QT_PIXEL_DEPTHS += 32
endif
ifneq ($(QT_PIXEL_DEPTHS),)
QT_CONFIGURE_OPTS += -depths $(subst $(space),$(comma),$(strip $(QT_PIXEL_DEPTHS)))
endif

### Display drivers
ifeq ($(BR2_PACKAGE_QT_GFX_LINUXFB),y)
QT_CONFIGURE_OPTS += -qt-gfx-linuxfb
else
QT_CONFIGURE_OPTS += -no-gfx-linuxfb
endif
ifeq ($(BR2_PACKAGE_QT_GFX_TRANSFORMED),y)
QT_CONFIGURE_OPTS += -qt-gfx-transformed
else
QT_CONFIGURE_OPTS += -no-gfx-transformed
endif
ifeq ($(BR2_PACKAGE_QT_GFX_QVFB),y)
QT_CONFIGURE_OPTS += -qt-gfx-qvfb
else
QT_CONFIGURE_OPTS += -no-gfx-qvfb
endif
ifeq ($(BR2_PACKAGE_QT_GFX_VNC),y)
QT_CONFIGURE_OPTS += -qt-gfx-vnc
else
QT_CONFIGURE_OPTS += -no-gfx-vnc
endif
ifeq ($(BR2_PACKAGE_QT_GFX_MULTISCREEN),y)
QT_CONFIGURE_OPTS += -qt-gfx-multiscreen
else
QT_CONFIGURE_OPTS += -no-gfx-multiscreen
endif
ifeq ($(BR2_PACKAGE_QT_GFX_DIRECTFB),y)
QT_CONFIGURE_OPTS += -qt-gfx-directfb
QT_DEPENDENCIES += directfb
else
QT_CONFIGURE_OPTS += -no-gfx-directfb
endif
ifeq ($(BR2_PACKAGE_QT_GFX_POWERVR),y)
QT_CONFIGURE_OPTS += \
	-plugin-gfx-powervr -D QT_NO_QWS_CURSOR -D QT_QWS_CLIENTBLIT
QT_DEPENDENCIES += powervr
endif

### Mouse drivers
ifeq ($(BR2_PACKAGE_QT_MOUSE_PC),y)
QT_CONFIGURE_OPTS += -qt-mouse-pc
else
QT_CONFIGURE_OPTS += -no-mouse-pc
endif
ifeq ($(BR2_PACKAGE_QT_MOUSE_LINUXTP),y)
QT_CONFIGURE_OPTS += -qt-mouse-linuxtp
else
QT_CONFIGURE_OPTS += -no-mouse-linuxtp
endif
ifeq ($(BR2_PACKAGE_QT_MOUSE_LINUXINPUT),y)
QT_CONFIGURE_OPTS += -qt-mouse-linuxinput
else
QT_CONFIGURE_OPTS += -no-mouse-linuxinput
endif
ifeq ($(BR2_PACKAGE_QT_MOUSE_TSLIB),y)
QT_CONFIGURE_OPTS += -qt-mouse-tslib
QT_DEPENDENCIES += tslib
else
QT_CONFIGURE_OPTS += -no-mouse-tslib
endif
ifeq ($(BR2_PACKAGE_QT_MOUSE_QVFB),y)
QT_CONFIGURE_OPTS += -qt-mouse-qvfb
else
QT_CONFIGURE_OPTS += -no-mouse-qvfb
endif
ifeq ($(BR2_PACKAGE_QT_MOUSE_NO_QWS_CURSOR),y)
QT_CONFIGURE_OPTS += -D QT_NO_QWS_CURSOR
endif

### Keyboard drivers
ifeq ($(BR2_PACKAGE_QT_KEYBOARD_TTY),y)
QT_CONFIGURE_OPTS += -qt-kbd-tty
else
QT_CONFIGURE_OPTS += -no-kbd-tty
endif
ifeq ($(BR2_PACKAGE_QT_KEYBOARD_LINUXINPUT),y)
QT_CONFIGURE_OPTS += -qt-kbd-linuxinput
else
QT_CONFIGURE_OPTS += -no-kbd-linuxinput
endif
ifeq ($(BR2_PACKAGE_QT_KEYBOARD_QVFB),y)
QT_CONFIGURE_OPTS += -qt-kbd-qvfb
else
QT_CONFIGURE_OPTS += -no-kbd-qvfb
endif

ifeq ($(BR2_PACKAGE_QT_DEBUG),y)
QT_CONFIGURE_OPTS += -debug
else
QT_CONFIGURE_OPTS += -release
endif

ifeq ($(BR2_PACKAGE_QT_SHARED),y)
QT_CONFIGURE_OPTS += -shared
else
QT_CONFIGURE_OPTS += -static
endif

ifeq ($(BR2_STATIC_LIBS),y)
QT_CONFIGURE_OPTS += -D QT_NO_DYNAMIC_LIBRARY
endif

ifeq ($(BR2_ENDIAN),"LITTLE")
QT_CONFIGURE_OPTS += -little-endian
else
QT_CONFIGURE_OPTS += -big-endian
endif

ifeq ($(BR2_arm)$(BR2_armeb),y)
QT_EMB_PLATFORM = arm
else ifeq ($(BR2_i386),y)
QT_EMB_PLATFORM = x86
else ifeq ($(BR2_x86_64),y)
QT_EMB_PLATFORM = x86_64
else ifeq ($(BR2_mips)$(BR2_mipsel),y)
QT_EMB_PLATFORM = mips
else ifeq ($(BR2_powerpc),y)
QT_EMB_PLATFORM = powerpc
else ifeq ($(BR2_sh4)$(BR2_sh4eb)$(BR2_sh4a)$(BR2_sh4aeb),y)
QT_EMB_PLATFORM = sh
else
QT_EMB_PLATFORM = generic
endif

ifeq ($(BR2_PACKAGE_QT_X11),y)
QT_DEPENDENCIES += fontconfig xlib_libXi xlib_libX11 xlib_libXrender \
	xlib_libXcursor xlib_libXrandr xlib_libXext xlib_libXv
# Using pkg-config avoids us some logic to redefine and sed again mkspecs files
# to add X11 include path and link options
QT_CFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags x11`
QT_CXXFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags x11`
QT_LDFLAGS += `$(PKG_CONFIG_HOST_BINARY) --libs x11 xext`
QT_CONFIGURE_OPTS += -arch $(QT_EMB_PLATFORM) \
		-xplatform qws/linux-$(QT_EMB_PLATFORM)-g++ -x11 -no-gtkstyle -no-sm \
		-no-openvg
else # if BR2_PACKAGE_QT_EMBEDDED
QT_CONFIGURE_OPTS += -embedded $(QT_EMB_PLATFORM)
endif

ifneq ($(BR2_PACKAGE_QT_GUI_MODULE),y)
QT_CONFIGURE_OPTS += -no-gui
endif

ifneq ($(BR2_PACKAGE_QT_GIF),y)
QT_CONFIGURE_OPTS += -no-gif
endif

ifeq ($(BR2_PACKAGE_QT_LIBMNG),y)
QT_CONFIGURE_OPTS += -qt-libmng
else
QT_CONFIGURE_OPTS += -no-libmng
endif

ifeq ($(BR2_PACKAGE_QT_ACCESSIBILITY),y)
QT_CONFIGURE_OPTS += -accessibility
else
QT_CONFIGURE_OPTS += -no-accessibility
endif

ifeq ($(BR2_PACKAGE_QT_QTZLIB),y)
QT_CONFIGURE_OPTS += -qt-zlib
else
ifeq ($(BR2_PACKAGE_QT_SYSTEMZLIB),y)
QT_CONFIGURE_OPTS += -system-zlib
QT_DEPENDENCIES += zlib
endif
endif

ifeq ($(BR2_PACKAGE_QT_QTJPEG),y)
QT_CONFIGURE_OPTS += -qt-libjpeg
else
ifeq ($(BR2_PACKAGE_QT_SYSTEMJPEG),y)
QT_CONFIGURE_OPTS += -system-libjpeg
QT_DEPENDENCIES += jpeg
else
QT_CONFIGURE_OPTS += -no-libjpeg
endif
endif

ifeq ($(BR2_PACKAGE_QT_QTPNG),y)
QT_CONFIGURE_OPTS += -qt-libpng
else
ifeq ($(BR2_PACKAGE_QT_SYSTEMPNG),y)
QT_CONFIGURE_OPTS += -system-libpng
QT_DEPENDENCIES += libpng
else
QT_CONFIGURE_OPTS += -no-libpng
endif
endif

ifeq ($(BR2_PACKAGE_QT_QTTIFF),y)
QT_CONFIGURE_OPTS += -qt-libtiff
else
ifeq ($(BR2_PACKAGE_QT_SYSTEMTIFF),y)
QT_CONFIGURE_OPTS += -system-libtiff
QT_DEPENDENCIES += tiff
else
QT_CONFIGURE_OPTS += -no-libtiff
endif
endif

QT_FONTS = $(addprefix $(STAGING_DIR)/usr/lib/fonts/, $(addsuffix *.qpf, \
	   $(if $(BR2_PACKAGE_QT_FONT_MICRO),micro) \
	   $(if $(BR2_PACKAGE_QT_FONT_FIXED),fixed) \
	   $(if $(BR2_PACKAGE_QT_FONT_HELVETICA),helvetica) \
	   $(if $(BR2_PACKAGE_QT_FONT_JAPANESE),japanese) \
	   $(if $(BR2_PACKAGE_QT_FONT_UNIFONT),unifont)))

ifeq ($(BR2_PACKAGE_QT_QTFREETYPE),y)
QT_CONFIGURE_OPTS += -qt-freetype
else
ifeq ($(BR2_PACKAGE_QT_SYSTEMFREETYPE),y)
QT_CONFIGURE_OPTS += -system-freetype
QT_CONFIGURE_OPTS += -I $(STAGING_DIR)/usr/include/freetype2/
QT_DEPENDENCIES += freetype
else
QT_CONFIGURE_OPTS += -no-freetype
endif
endif

ifeq ($(BR2_PACKAGE_QT_DBUS),y)
QT_DEPENDENCIES += dbus
endif

ifeq ($(BR2_PACKAGE_QT_OPENSSL),y)
QT_CONFIGURE_OPTS += -openssl
QT_DEPENDENCIES += openssl
else
QT_CONFIGURE_OPTS += -no-openssl
endif

ifeq ($(BR2_PACKAGE_QT_OPENGL_ES),y)
QT_CONFIGURE_OPTS += -opengl es2 -egl
QT_DEPENDENCIES += libgles libegl
QT_CFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags egl`
QT_CXXFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags egl`
QT_LDFLAGS += `$(PKG_CONFIG_HOST_BINARY) --libs egl`
else ifeq ($(BR2_PACKAGE_QT_OPENGL_GL_DESKTOP),y)
QT_CONFIGURE_OPTS += -opengl desktop
QT_DEPENDENCIES += libgl
else
QT_CONFIGURE_OPTS += -no-opengl
endif

# Qt SQL Drivers
ifeq ($(BR2_PACKAGE_QT_SQL_MODULE),y)
ifeq ($(BR2_PACKAGE_QT_MYSQL),y)
QT_CONFIGURE_OPTS += -qt-sql-mysql -mysql_config $(STAGING_DIR)/usr/bin/mysql_config
QT_DEPENDENCIES += mysql
endif
ifeq ($(BR2_PACKAGE_QT_ODBC),y)
QT_CONFIGURE_OPTS += -qt-sql-odbc
QT_DEPENDENCIES += unixodbc
endif
ifeq ($(BR2_PACKAGE_QT_PSQL),y)
QT_CONFIGURE_OPTS += -qt-sql-psql -psql_config $(STAGING_DIR)/usr/bin/pg_config
QT_DEPENDENCIES += postgresql
endif
ifeq ($(BR2_PACKAGE_QT_SQLITE_QT),y)
QT_CONFIGURE_OPTS += -qt-sql-sqlite
else
ifeq ($(BR2_PACKAGE_QT_SQLITE_SYSTEM),y)
QT_CONFIGURE_OPTS += -system-sqlite
QT_DEPENDENCIES += sqlite
else
QT_CONFIGURE_OPTS += -no-sql-sqlite
endif
endif
ifeq ($(BR2_PACKAGE_QT_SQLITE2),y)
QT_CONFIGURE_OPTS += -qt-sql-sqlite2
endif
else
# By default, no SQL driver is turned on by configure.
# but it seems sqlite isn't disabled despite what says
# configure --help
QT_CONFIGURE_OPTS += -no-sql-sqlite
endif

ifeq ($(BR2_PACKAGE_QT_XMLPATTERNS),y)
QT_CONFIGURE_OPTS += -xmlpatterns -exceptions
else
QT_CONFIGURE_OPTS += -no-xmlpatterns
endif

ifeq ($(BR2_PACKAGE_QT_MULTIMEDIA),y)
QT_CONFIGURE_OPTS += -multimedia
else
QT_CONFIGURE_OPTS += -no-multimedia
endif

ifeq ($(BR2_PACKAGE_QT_AUDIO_BACKEND),y)
QT_CONFIGURE_OPTS += -audio-backend
QT_DEPENDENCIES += alsa-lib
else
QT_CONFIGURE_OPTS += -no-audio-backend
endif

ifeq ($(BR2_PACKAGE_QT_PHONON),y)
QT_CONFIGURE_OPTS += -phonon
QT_DEPENDENCIES += gstreamer gst-plugins-base
else
QT_CONFIGURE_OPTS += -no-phonon
endif

ifeq ($(BR2_PACKAGE_QT_PHONON_BACKEND),y)
QT_CONFIGURE_OPTS += -phonon-backend
else
QT_CONFIGURE_OPTS += -no-phonon-backend
endif

ifeq ($(BR2_PACKAGE_QT_SVG),y)
QT_CONFIGURE_OPTS += -svg
else
QT_CONFIGURE_OPTS += -no-svg
endif

ifeq ($(BR2_PACKAGE_QT_WEBKIT),y)
QT_CONFIGURE_OPTS += -webkit
QT_DEPENDENCIES += gstreamer gst-plugins-base
else
QT_CONFIGURE_OPTS += -no-webkit
endif

ifeq ($(BR2_PACKAGE_QT_SCRIPT),y)
QT_CONFIGURE_OPTS += -script
else
QT_CONFIGURE_OPTS += -no-script
endif

ifeq ($(BR2_PACKAGE_QT_SCRIPTTOOLS),y)
QT_CONFIGURE_OPTS += -scripttools
else
QT_CONFIGURE_OPTS += -no-scripttools
endif

ifeq ($(BR2_PACKAGE_QT_STL),y)
QT_CONFIGURE_OPTS += -stl
else
QT_CONFIGURE_OPTS += -no-stl
endif

ifeq ($(BR2_PACKAGE_QT_DECLARATIVE),y)
QT_CONFIGURE_OPTS += -declarative
else
QT_CONFIGURE_OPTS += -no-declarative
endif

# -no-pch is needed to workaround the issue described at
# http://comments.gmane.org/gmane.comp.lib.qt.devel/5933.
# In addition, ccache and precompiled headers don't play well together
QT_CONFIGURE_OPTS += -no-pch

# x86x86fix
# Workaround Qt Embedded bug when crosscompiling for x86 under x86 with linux
# host. It's unclear if this would happen on other hosts.
ifneq ($(findstring linux,$(GNU_HOST_NAME)),)
ifneq ($(findstring x86,$(QT_EMB_PLATFORM)),)
QT_CONFIGURE_OPTS += -platform linux-g++
endif
endif
# End of workaround.

# Variable for other Qt applications to use
QT_QMAKE = $(HOST_DIR)/usr/bin/qmake -spec qws/linux-$(QT_EMB_PLATFORM)-g++

################################################################################
# QT_QMAKE_SET -- helper macro to set <variable> = <value> in
# the qmake.conf file. Will remove existing variable declaration if
# available.
#
# Argument 1 is the variable name
# Argument 2 is the value to set variable to
# Argument 3 is the base source directory of Qt
#
# E.G. use like this:
# $(call QT_QMAKE_SET,variable,value,directory)
################################################################################
define QT_QMAKE_SET
	$(SED) '/$(1)/d' $(3)/mkspecs/qws/linux-$(QT_EMB_PLATFORM)-g++/qmake.conf
	$(SED) "/include.*qws.conf/a$(1) = $(2)" $(3)/mkspecs/qws/linux-$(QT_EMB_PLATFORM)-g++/qmake.conf
endef

ifneq ($(QT_CONFIG_FILE),)
define QT_CONFIGURE_CONFIG_FILE
	cp $(QT_CONFIG_FILE) $(@D)/src/corelib/global/qconfig-buildroot.h
endef
endif

define QT_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) confclean
	$(QT_CONFIGURE_IPV6)
	$(QT_CONFIGURE_CONFIG_FILE)
	# Fix compiler path
	$(call QT_QMAKE_SET,QMAKE_CC,$(TARGET_CC),$(@D))
	$(call QT_QMAKE_SET,QMAKE_CXX,$(TARGET_CXX),$(@D))
	$(call QT_QMAKE_SET,QMAKE_LINK,$(TARGET_CXX),$(@D))
	$(call QT_QMAKE_SET,QMAKE_LINK_SHLIB,$(TARGET_CXX),$(@D))
	$(call QT_QMAKE_SET,QMAKE_AR,$(TARGET_AR) cqs,$(@D))
	$(call QT_QMAKE_SET,QMAKE_OBJCOPY,$(TARGET_OBJCOPY),$(@D))
	$(call QT_QMAKE_SET,QMAKE_RANLIB,$(TARGET_RANLIB),$(@D))
	$(call QT_QMAKE_SET,QMAKE_STRIP,$(TARGET_STRIP),$(@D))
	$(call QT_QMAKE_SET,QMAKE_CFLAGS,$(QT_CFLAGS),$(@D))
	$(call QT_QMAKE_SET,QMAKE_CXXFLAGS,$(QT_CXXFLAGS),$(@D))
	$(call QT_QMAKE_SET,QMAKE_LFLAGS,$(QT_LDFLAGS),$(@D))
	$(call QT_QMAKE_SET,PKG_CONFIG,$(HOST_DIR)/usr/bin/pkg-config,$(@D))
# Don't use TARGET_CONFIGURE_OPTS here, qmake would be compiled for the target
# instead of the host then. So set PKG_CONFIG* manually.
	(cd $(@D); \
		PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)" \
		PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
		PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig:$(PKG_CONFIG_PATH)" \
		$(TARGET_MAKE_ENV) \
		MAKEFLAGS="$(MAKEFLAGS) -j$(PARALLEL_JOBS)" ./configure \
		$(if $(VERBOSE),-verbose,-silent) \
		-force-pkg-config \
		$(QT_CONFIGURE_OPTS) \
		-no-xinerama \
		-no-cups \
		-no-nis \
		-no-separate-debug-info \
		-prefix /usr \
		-plugindir /usr/lib/qt/plugins \
		-importdir /usr/lib/qt/imports \
		-translationdir /usr/share/qt/translations \
		-hostprefix $(STAGING_DIR) \
		-fast \
		-no-rpath \
	)
endef

define QT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

# Build the list of libraries and plugins to install to the target

QT_INSTALL_LIBS += QtCore
QT_HOST_PROGRAMS += moc rcc qmake lrelease

ifeq ($(BR2_PACKAGE_QT_GUI_MODULE),y)
QT_INSTALL_LIBS += QtGui
QT_HOST_PROGRAMS += uic
endif
ifeq ($(BR2_PACKAGE_QT_SQL_MODULE),y)
QT_INSTALL_LIBS += QtSql
endif
ifeq ($(BR2_PACKAGE_QT_MULTIMEDIA),y)
QT_INSTALL_LIBS += QtMultimedia
endif
ifeq ($(BR2_PACKAGE_QT_PHONON),y)
QT_INSTALL_LIBS += phonon
endif
ifeq ($(BR2_PACKAGE_QT_SVG),y)
QT_INSTALL_LIBS += QtSvg
endif
ifeq ($(BR2_PACKAGE_QT_NETWORK),y)
QT_INSTALL_LIBS += QtNetwork
endif
ifeq ($(BR2_PACKAGE_QT_WEBKIT),y)
QT_INSTALL_LIBS += QtWebKit
endif
ifeq ($(BR2_PACKAGE_QT_XML),y)
QT_INSTALL_LIBS += QtXml
endif
ifeq ($(BR2_PACKAGE_QT_DBUS),y)
QT_INSTALL_LIBS += QtDBus
endif
ifeq ($(BR2_PACKAGE_QT_XMLPATTERNS),y)
QT_INSTALL_LIBS += QtXmlPatterns
endif
ifeq ($(BR2_PACKAGE_QT_SCRIPT),y)
QT_INSTALL_LIBS += QtScript
endif
ifeq ($(BR2_PACKAGE_QT_SCRIPTTOOLS),y)
QT_INSTALL_LIBS += QtScriptTools
endif
ifeq ($(BR2_PACKAGE_QT_DECLARATIVE),y)
QT_INSTALL_LIBS += QtDeclarative
endif
ifeq ($(BR2_PACKAGE_QT_QT3SUPPORT),y)
QT_INSTALL_LIBS += Qt3Support
endif
ifeq ($(BR2_PACKAGE_QT_OPENGL_ES),y)
QT_INSTALL_LIBS += QtOpenGL
endif
ifeq ($(BR2_PACKAGE_QT_GFX_POWERVR),y)
QT_INSTALL_LIBS += pvrQWSWSEGL
endif
ifeq ($(BR2_PACKAGE_QT_TEST),y)
QT_INSTALL_LIBS += QtTest
endif

QT_CONF_FILE = $(HOST_DIR)/usr/bin/qt.conf

# Since host programs and spec files have been moved to $(HOST_DIR),
# we need to tell qmake the new location of the various elements,
# through a qt.conf file.
define QT_INSTALL_QT_CONF
	mkdir -p $(dir $(QT_CONF_FILE))
	echo "[Paths]"                             > $(QT_CONF_FILE)
	echo "Prefix=$(HOST_DIR)/usr"             >> $(QT_CONF_FILE)
	echo "Headers=$(STAGING_DIR)/usr/include" >> $(QT_CONF_FILE)
	echo "Libraries=$(STAGING_DIR)/usr/lib"   >> $(QT_CONF_FILE)
	echo "Data=$(HOST_DIR)/usr"               >> $(QT_CONF_FILE)
	echo "Binaries=$(HOST_DIR)/usr/bin"       >> $(QT_CONF_FILE)
endef

# After running Qt normal installation process (which installs
# everything in the STAGING_DIR), we move host programs such as qmake,
# rcc or uic to the HOST_DIR so that they are available at the usual
# location. A qt.conf file is generated to make sure that all host
# programs still find all files they need. The .pc files are tuned to
# remove the sysroot path from them, since pkg-config already adds it
# automatically.
define QT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	mkdir -p $(HOST_DIR)/usr/bin
	mv $(addprefix $(STAGING_DIR)/usr/bin/,$(QT_HOST_PROGRAMS)) $(HOST_DIR)/usr/bin
	ln -sf $(STAGING_DIR)/usr/mkspecs $(HOST_DIR)/usr/mkspecs
	$(QT_INSTALL_QT_CONF)
	for i in moc uic rcc lupdate lrelease ; do \
		$(SED) "s,^$${i}_location=.*,$${i}_location=$(HOST_DIR)/usr/bin/$${i}," \
			$(STAGING_DIR)/usr/lib/pkgconfig/Qt*.pc ; \
	done
	$(SED) "s,$(STAGING_DIR)/,,g" $(STAGING_DIR)/usr/lib/pkgconfig/Qt*.pc
endef

# Library installation
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
define QT_INSTALL_TARGET_LIBS
	mkdir -p $(TARGET_DIR)/usr/lib
	for lib in $(QT_INSTALL_LIBS); do \
		cp -dpf $(STAGING_DIR)/usr/lib/lib$${lib}.so.* $(TARGET_DIR)/usr/lib ; \
	done
endef
endif

# Plugin installation
define QT_INSTALL_TARGET_PLUGINS
	if [ -d $(STAGING_DIR)/usr/lib/qt/plugins/ ] ; then \
		mkdir -p $(TARGET_DIR)/usr/lib/qt/plugins ; \
		cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/* $(TARGET_DIR)/usr/lib/qt/plugins ; \
	fi
endef

# Import installation
define QT_INSTALL_TARGET_IMPORTS
	if [ -d $(STAGING_DIR)/usr/lib/qt/imports/ ] ; then \
		mkdir -p $(TARGET_DIR)/usr/lib/qt/imports ; \
		cp -dpfr $(STAGING_DIR)/usr/lib/qt/imports/* $(TARGET_DIR)/usr/lib/qt/imports ; \
	fi
endef

# Fonts installation
ifeq ($(BR2_PACKAGE_QT_EMBEDDED),y)
ifneq ($(QT_FONTS),)
define QT_INSTALL_TARGET_FONTS
	mkdir -p $(TARGET_DIR)/usr/lib/fonts
	cp -dpf $(QT_FONTS) $(TARGET_DIR)/usr/lib/fonts
endef
ifneq ($(BR2_PACKAGE_QT_FONT_MICRO)$(BR2_PACKAGE_QT_FONT_FIXED),)
# as stated in the font source src/3rdparty/fonts/micro.bdf
# source src/3rdparty/fonts/5x7.bdf and source src/3rdparty/fonts/6x13.bdf
QT_LICENSE := $(QT_LICENSE), Public Domain (Micro/Fixed font)
endif
ifneq ($(BR2_PACKAGE_QT_FONT_HELVETICA)$(BR2_PACKAGE_QT_FONT_JAPANESE),)
QT_LICENSE := $(QT_LICENSE), Adobe Helvetica license (Helvetica/Japanese fonts)
QT_LICENSE_FILES += src/3rdparty/fonts/COPYING.Helvetica
endif
ifeq ($(BR2_PACKAGE_QT_FONT_UNIFONT),y)
QT_LICENSE := $(QT_LICENSE), Freeware (Unifont font)
QT_LICENSE_FILES += src/3rdparty/fonts/COPYRIGHT.Unifont
endif
endif # QT_FONTS

ifeq ($(BR2_PACKAGE_QT_FONT_TRUETYPE),y)
define QT_INSTALL_TARGET_FONTS_TTF
	mkdir -p $(TARGET_DIR)/usr/lib/fonts
	cp -dpf $(STAGING_DIR)/usr/lib/fonts/*.ttf $(TARGET_DIR)/usr/lib/fonts
endef
QT_LICENSE := $(QT_LICENSE), Bitstream license (DejaVu/Vera TrueType fonts)
QT_LICENSE_FILES += src/3rdparty/fonts/COPYRIGHT.DejaVu \
	src/3rdparty/fonts/README.DejaVu \
	src/3rdparty/fonts/COPYRIGHT.Vera
endif
endif # BR2_PACKAGE_QT_EMBEDDED

ifeq ($(BR2_PACKAGE_QT_GFX_POWERVR),y)
define QT_INSTALL_TARGET_POWERVR
	# Note: this overwrites the default powervr.ini provided by the ti-gfx
	# package.
	$(INSTALL) -D -m 0644 package/qt/powervr.ini \
		$(TARGET_DIR)/etc/powervr.ini
endef
endif

ifeq ($(BR2_PACKAGE_QT_TRANSLATION_FILES),y)
define QT_INSTALL_TARGET_TRANSLATIONS
	if [ -d $(STAGING_DIR)/usr/share/qt/translations/ ] ; then \
		mkdir -p $(TARGET_DIR)/usr/share/qt/translations ; \
		cp -dpfr $(STAGING_DIR)/usr/share/qt/translations/* $(TARGET_DIR)/usr/share/qt/translations ; \
	fi
endef
endif

define QT_INSTALL_TARGET_CMDS
	$(QT_INSTALL_TARGET_LIBS)
	$(QT_INSTALL_TARGET_PLUGINS)
	$(QT_INSTALL_TARGET_IMPORTS)
	$(QT_INSTALL_TARGET_FONTS)
	$(QT_INSTALL_TARGET_FONTS_TTF)
	$(QT_INSTALL_TARGET_POWERVR)
	$(QT_INSTALL_TARGET_TRANSLATIONS)
endef

$(eval $(generic-package))
