######################################################################
#
# Qt Embedded for Linux
# http://www.qtsoftware.com/
#
# This makefile was originally composed by Thomas Lundquist <thomasez@zelow.no>
# Later heavily modified by buildroot developers
#
# BTW, this uses alot of FPU calls and it's pretty slow if you use
# the kernels FPU emulation so it's better to choose soft float in the
# buildroot config (and uClibc.config of course, if you have your own.)
#
######################################################################

QT_VERSION:=4.7.1
QT_SOURCE:=qt-everywhere-opensource-src-$(QT_VERSION).tar.gz
QT_SITE:=http://get.qt.nokia.com/qt/source
QT_CAT:=$(ZCAT)
QT_TARGET_DIR:=$(BUILD_DIR)/qt-everywhere-opensource-src-$(QT_VERSION)

QT_CONFIGURE:=#empty

ifeq ($(BR2_PACKAGE_QT_LICENSE_APPROVED),y)
QT_CONFIGURE += -opensource -confirm-license
endif

# If you want extra tweaking you can copy
# $(QT_TARGET_DIR)/src/corelib/global/qconfig-myfile.h
# to the qt packages directory (where this .mk file is) and
# remove the comment.
# QT_QCONFIG_COMMAND:=-qconfig myfile
#
# For the options you can set in this file, look at
# $(QT_TARGET_DIR)/src/corelib/global/qfeatures.txt
#
QT_QCONFIG_FILE:=package/qt/qconfig-myfile.h
QT_QCONFIG_FILE_LOCATION:=/src/corelib/global/

ifeq ($(BR2_LARGEFILE),y)
QT_CONFIGURE+= -largefile
else
QT_CONFIGURE+= -no-largefile
endif

ifeq ($(BR2_PACKAGE_QT_QT3SUPPORT),y)
QT_CONFIGURE+= -qt3support
else
QT_CONFIGURE+= -no-qt3support
endif

ifeq ($(BR2_PACKAGE_QT_DEMOS),y)
QT_CONFIGURE+= -examplesdir $(TARGET_DIR)/usr/share/qt/examples -demosdir $(TARGET_DIR)/usr/share/qt/demos
else
QT_CONFIGURE+= -nomake examples -nomake demos
endif

# ensure glib is built first if enabled for Qt's glib support
ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
QT_DEP_LIBS+=libglib2
endif


### Pixel depths
QT_PIXEL_DEPTHS := # empty
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
QT_CONFIGURE += -depths $(subst $(space),$(comma),$(strip $(QT_PIXEL_DEPTHS)))
endif

### Display drivers
ifeq ($(BR2_PACKAGE_QT_GFX_LINUXFB),y)
QT_CONFIGURE += -qt-gfx-linuxfb
else
QT_CONFIGURE += -no-gfx-linuxfb
endif
ifeq ($(BR2_PACKAGE_QT_GFX_TRANSFORMED),y)
QT_CONFIGURE += -qt-gfx-transformed
else
QT_CONFIGURE += -no-gfx-transformed
endif
ifeq ($(BR2_PACKAGE_QT_GFX_QVFB),y)
QT_CONFIGURE += -qt-gfx-qvfb
else
QT_CONFIGURE += -no-gfx-qvfb
endif
ifeq ($(BR2_PACKAGE_QT_GFX_VNC),y)
QT_CONFIGURE += -qt-gfx-vnc
else
QT_CONFIGURE += -no-gfx-vnc
endif
ifeq ($(BR2_PACKAGE_QT_GFX_MULTISCREEN),y)
QT_CONFIGURE += -qt-gfx-multiscreen
else
QT_CONFIGURE += -no-gfx-multiscreen
endif
ifeq ($(BR2_PACKAGE_QT_GFX_DIRECTFB),y)
QT_CONFIGURE += -qt-gfx-directfb
QT_DEP_LIBS+=directfb
else
QT_CONFIGURE += -no-gfx-directfb
endif


### Mouse drivers
ifeq ($(BR2_PACKAGE_QT_MOUSE_PC),y)
QT_CONFIGURE += -qt-mouse-pc
else
QT_CONFIGURE += -no-mouse-pc
endif
ifeq ($(BR2_PACKAGE_QT_MOUSE_LINUXTP),y)
QT_CONFIGURE += -qt-mouse-linuxtp
else
QT_CONFIGURE += -no-mouse-linuxtp
endif
ifeq ($(BR2_PACKAGE_QT_MOUSE_LINUXINPUT),y)
QT_CONFIGURE += -qt-mouse-linuxinput
else
QT_CONFIGURE += -no-mouse-linuxinput
endif
ifeq ($(BR2_PACKAGE_QT_MOUSE_TSLIB),y)
QT_CONFIGURE += -qt-mouse-tslib
QT_DEP_LIBS+=tslib
else
QT_CONFIGURE += -no-mouse-tslib
endif
ifeq ($(BR2_PACKAGE_QT_MOUSE_QVFB),y)
QT_CONFIGURE += -qt-mouse-qvfb
else
QT_CONFIGURE += -no-mouse-qvfb
endif
ifeq ($(BR2_PACKAGE_QT_MOUSE_NO_QWS_CURSOR),y)
QT_CONFIGURE+= -D QT_NO_QWS_CURSOR
endif

### Keyboard drivers
ifeq ($(BR2_PACKAGE_QT_KEYBOARD_TTY),y)
QT_CONFIGURE += -qt-kbd-tty
else
QT_CONFIGURE += -no-kbd-tty
endif
ifeq ($(BR2_PACKAGE_QT_KEYBOARD_LINUXINPUT),y)
QT_CONFIGURE += -qt-kbd-linuxinput
else
QT_CONFIGURE += -no-kbd-linuxinput
endif
ifeq ($(BR2_PACKAGE_QT_KEYBOARD_QVFB),y)
QT_CONFIGURE += -qt-kbd-qvfb
else
QT_CONFIGURE += -no-kbd-qvfb
endif

ifeq ($(BR2_PACKAGE_QT_DEBUG),y)
QT_CONFIGURE+= -debug
else
QT_CONFIGURE+= -release
endif

ifeq ($(BR2_PACKAGE_QT_SHARED),y)
QT_CONFIGURE+= -shared
else
QT_CONFIGURE+= -static
endif

ifeq ($(BR2_ENDIAN),"LITTLE")
QT_CONFIGURE+= -little-endian
else
QT_CONFIGURE+= -big-endian
endif

ifneq ($(BR2_PACKAGE_QT_GUI_MODULE),y)
QT_CONFIGURE+= -no-gui
endif

ifeq ($(BR2_PACKAGE_QT_GIF),y)
QT_CONFIGURE+= -qt-gif
else
QT_CONFIGURE+= -no-gif
endif

ifeq ($(BR2_PACKAGE_QT_LIBMNG),y)
QT_CONFIGURE+= -qt-libmng
else
QT_CONFIGURE+= -no-libmng
endif

ifeq ($(BR2_PACKAGE_QT_QTZLIB),y)
QT_CONFIGURE+= -qt-zlib
else
ifeq ($(BR2_PACKAGE_QT_SYSTEMZLIB),y)
QT_CONFIGURE+= -system-zlib
QT_DEP_LIBS+=zlib
endif
endif

ifeq ($(BR2_PACKAGE_QT_QTJPEG),y)
QT_CONFIGURE+= -qt-libjpeg
else
ifeq ($(BR2_PACKAGE_QT_SYSTEMJPEG),y)
QT_CONFIGURE+= -system-libjpeg
QT_DEP_LIBS+=jpeg
else
QT_CONFIGURE+= -no-libjpeg
endif
endif

ifeq ($(BR2_PACKAGE_QT_QTPNG),y)
QT_CONFIGURE+= -qt-libpng
else
ifeq ($(BR2_PACKAGE_QT_SYSTEMPNG),y)
QT_CONFIGURE+= -system-libpng
QT_DEP_LIBS+=libpng
else
QT_CONFIGURE+= -no-libpng
endif
endif

ifeq ($(BR2_PACKAGE_QT_QTTIFF),y)
QT_CONFIGURE+= -qt-libtiff
else
ifeq ($(BR2_PACKAGE_QT_SYSTEMTIFF),y)
QT_CONFIGURE+= -system-libtiff
QT_DEP_LIBS+=tiff
else
QT_CONFIGURE+= -no-libtiff
endif
endif


QT_FONTS = $(addprefix $(STAGING_DIR)/usr/lib/fonts/, $(addsuffix *.qpf, \
	   $(if $(BR2_PACKAGE_QT_FONT_MICRO),micro) \
	   $(if $(BR2_PACKAGE_QT_FONT_FIXED),fixed) \
	   $(if $(BR2_PACKAGE_QT_FONT_HELVETICA),helvetica) \
	   $(if $(BR2_PACKAGE_QT_FONT_JAPANESE),japanese) \
	   $(if $(BR2_PACKAGE_QT_FONT_UNIFONT),unifont)))


ifeq ($(BR2_PACKAGE_QT_QTFREETYPE),y)
QT_CONFIGURE+= -qt-freetype
else
ifeq ($(BR2_PACKAGE_QT_SYSTEMFREETYPE),y)
QT_CONFIGURE+= -system-freetype
QT_CONFIGURE+= -I $(STAGING_DIR)/usr/include/freetype2/
QT_DEP_LIBS+=freetype
else
QT_CONFIGURE+= -no-freetype
endif
endif


ifeq ($(BR2_PACKAGE_QT_OPENSSL),y)
QT_CONFIGURE+= -openssl
QT_DEP_LIBS+=openssl
else
QT_CONFIGURE+= -no-openssl
endif

# Qt SQL Drivers
ifeq ($(BR2_PACKAGE_QT_SQL_MODULE),y)
ifeq ($(BR2_PACKAGE_QT_IBASE),y)
QT_CONFIGURE+= -qt-sql-ibase
endif
ifeq ($(BR2_PACKAGE_QT_MYSQL),y)
QT_CONFIGURE+= -qt-sql-mysql -mysql_config $(STAGING_DIR)/usr/bin/mysql_config
QT_DEP_LIBS+=mysql_client
endif
ifeq ($(BR2_PACKAGE_QT_ODBC),y)
QT_CONFIGURE+= -qt-sql-odbc
endif
ifeq ($(BR2_PACKAGE_QT_PSQL),y)
QT_CONFIGURE+= -qt-sql-psql
endif
ifeq ($(BR2_PACKAGE_QT_SQLITE),y)
QT_CONFIGURE+= -qt-sql-sqlite
else
QT_CONFIGURE+= -no-sql-sqlite
endif
ifeq ($(BR2_PACKAGE_QT_SQLITE2),y)
QT_CONFIGURE+= -qt-sql-sqlite2
endif
else
# By default, no SQL driver is turned on by configure.
# but it seams sqlite isn't disabled despite what says
# configure --help
QT_CONFIGURE+= -no-sql-sqlite
endif

ifeq ($(BR2_PACKAGE_QT_XMLPATTERNS),y)
QT_CONFIGURE+= -xmlpatterns -exceptions
else
QT_CONFIGURE+= -no-xmlpatterns
endif

ifeq ($(BR2_PACKAGE_QT_MULTIMEDIA),y)
QT_CONFIGURE+= -multimedia
else
QT_CONFIGURE+= -no-multimedia
endif

ifeq ($(BR2_PACKAGE_QT_AUDIO_BACKEND),y)
QT_CONFIGURE+= -audio-backend
QT_DEP_LIBS+=alsa-lib
else
QT_CONFIGURE+= -no-audio-backend
endif

ifeq ($(BR2_PACKAGE_QT_PHONON),y)
QT_CONFIGURE+= -phonon
QT_DEP_LIBS+=gstreamer gst-plugins-base
else
QT_CONFIGURE+= -no-phonon
endif

ifeq ($(BR2_PACKAGE_QT_PHONON_BACKEND),y)
QT_CONFIGURE+= -phonon-backend
else
QT_CONFIGURE+= -no-phonon-backend
endif

ifeq ($(BR2_PACKAGE_QT_SVG),y)
QT_CONFIGURE+= -svg
else
QT_CONFIGURE+= -no-svg
endif

ifeq ($(BR2_PACKAGE_QT_WEBKIT),y)
QT_CONFIGURE+= -webkit
else
QT_CONFIGURE+= -no-webkit
endif

ifeq ($(BR2_PACKAGE_QT_SCRIPT),y)
QT_CONFIGURE+= -script
else
QT_CONFIGURE+= -no-script
endif

ifeq ($(BR2_PACKAGE_QT_SCRIPTTOOLS),y)
QT_CONFIGURE+= -scripttools
else
QT_CONFIGURE+= -no-scripttools
endif

ifeq ($(BR2_PACKAGE_QT_JAVASCRIPTCORE),y)
QT_CONFIGURE+= -javascript-jit
else
QT_CONFIGURE+= -no-javascript-jit
endif

ifeq ($(BR2_PACKAGE_QT_STL),y)
QT_CONFIGURE+= -stl
else
QT_CONFIGURE+= -no-stl
endif

# ccache and precompiled headers don't play well together
ifeq ($(BR2_CCACHE),y)
QT_CONFIGURE += -no-pch
endif

BR2_PACKAGE_QT_EMB_PLATFORM:=$(call qstrip,$(BR2_PACKAGE_QT_EMB_PLATFORM))

# x86x86fix
# Workaround Qt Embedded bug when crosscompiling for x86 under x86 with linux
# host. It's unclear if this would happen on other hosts.
ifneq ($(findstring linux,$(GNU_HOST_NAME)),)
ifneq ($(findstring x86,$(BR2_PACKAGE_QT_EMB_PLATFORM)),)
QT_CONFIGURE+= -platform linux-g++
endif
endif
# End of workaround.

# Figure out what libs to install in the target
QT_LIBS=#empty
ifeq ($(BR2_PACKAGE_QT_GUI_MODULE),y)
QT_LIBS+= qt-gui  
endif
ifeq ($(BR2_PACKAGE_QT_SQL_MODULE),y)
QT_LIBS+= qt-sql
endif
ifeq ($(BR2_PACKAGE_QT_MULTIMEDIA),y)
QT_LIBS+= qt-multimedia
endif
ifeq ($(BR2_PACKAGE_QT_PHONON),y)
QT_LIBS+= qt-phonon
endif
ifeq ($(BR2_PACKAGE_QT_SVG),y)
QT_LIBS+= qt-svg
endif
ifeq ($(BR2_PACKAGE_QT_NETWORK),y)
QT_LIBS+= qt-network
endif
ifeq ($(BR2_PACKAGE_QT_WEBKIT),y)
QT_LIBS+= qt-webkit
endif
ifeq ($(BR2_PACKAGE_QT_XML),y)
QT_LIBS+= qt-xml
endif
ifeq ($(BR2_PACKAGE_QT_DBUS),y)
QT_LIBS+= qt-dbus
QT_DEP_LIBS+= dbus
endif
ifeq ($(BR2_PACKAGE_QT_XMLPATTERNS),y)
QT_LIBS+= qt-xmlpatterns
endif
ifeq ($(BR2_PACKAGE_QT_SCRIPT),y)
QT_LIBS+= qt-script
endif
ifeq ($(BR2_PACKAGE_QT_SCRIPTTOOLS),y)
QT_LIBS+= qt-scripttools
endif
ifeq ($(BR2_PACKAGE_QT_QT3SUPPORT),y)
QT_LIBS+= qt-qt3support
endif

QT_QMAKE_CONF:=$(QT_TARGET_DIR)/mkspecs/qws/linux-$(BR2_PACKAGE_QT_EMB_PLATFORM)-g++/qmake.conf

# Variable for other Qt applications to use
QT_QMAKE:=$(HOST_DIR)/usr/bin/qmake -spec qws/linux-$(BR2_PACKAGE_QT_EMB_PLATFORM)-g++

################################################################################
# QT_QMAKE_SET -- helper macro to set QMAKE_<variable> = <value> in
# QT_QMAKE_CONF. Will remove existing variable declaration if available.
#
# Argument 1 is the variable name (without QMAKE_)
# Argument 2 is the value to set variable to
#
# E.G. use like this:
# $(call QT_QMAKE_SET,variable,value)
################################################################################
define QT_QMAKE_SET
	$(SED) '/QMAKE_$(1)/d' $(QT_QMAKE_CONF)
	$(SED) '/include.*qws.conf/aQMAKE_$(1) = $(2)' $(QT_QMAKE_CONF)
endef

################################################################################
# QT_INSTALL_PLUGINS -- helper macro to install Qt plugins to target and 
# strip them
#
# Argument 1 is the plugin folder
# 
# E.G. use like this to install plugins/sqldrivers:
# $(call QT_INSTALL_PLUGINS,sqldrivers)
# ################################################################################
define QT_INSTALL_PLUGINS
        if [ -d $(STAGING_DIR)/usr/plugins/$(1) ]; then \
                mkdir -p $(TARGET_DIR)/usr/plugins; \
                cp -dpfr $(STAGING_DIR)/usr/plugins/$(1) $(TARGET_DIR)/usr/plugins/; \
                $(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/plugins/$(1)/*; \
        fi
endef

$(DL_DIR)/$(QT_SOURCE):
	$(call DOWNLOAD,$(QT_SITE),$(QT_SOURCE))

qt-source: $(DL_DIR)/$(QT_SOURCE)


$(QT_TARGET_DIR)/.unpacked: $(DL_DIR)/$(QT_SOURCE)
	$(QT_CAT) $(DL_DIR)/$(QT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(QT_TARGET_DIR) package/qt/ \
		qt-$(QT_VERSION)-\*.patch \
		qt-$(QT_VERSION)-\*.patch.$(ARCH)
	touch $@

$(QT_TARGET_DIR)/.configured: $(QT_TARGET_DIR)/.unpacked
	-[ -f $(QT_TARGET_DIR)/Makefile ] && $(MAKE) -C $(QT_TARGET_DIR) confclean
ifneq ($(BR2_INET_IPV6),y)
	$(SED) 's/^CFG_IPV6=auto/CFG_IPV6=no/' $(QT_TARGET_DIR)/configure
	$(SED) 's/^CFG_IPV6IFNAME=auto/CFG_IPV6IFNAME=no/' $(QT_TARGET_DIR)/configure
endif
	# Fix compiler path
	$(call QT_QMAKE_SET,CC,$(filter-out --sysroot=%,$(TARGET_CC)))
	$(call QT_QMAKE_SET,CXX,$(filter-out --sysroot=%,$(TARGET_CXX)))
	$(call QT_QMAKE_SET,LINK,$(TARGET_CXX))
	$(call QT_QMAKE_SET,LINK_SHLIB,$(TARGET_CXX))
	$(call QT_QMAKE_SET,AR,$(TARGET_AR) cqs)
	$(call QT_QMAKE_SET,OBJCOPY,$(TARGET_OBJCOPY))
	$(call QT_QMAKE_SET,RANLIB,$(TARGET_RANLIB))
	$(call QT_QMAKE_SET,STRIP,$(TARGET_STRIP))
	$(call QT_QMAKE_SET,CFLAGS,$(TARGET_SYSROOT_OPT) $(TARGET_CFLAGS))
	$(call QT_QMAKE_SET,CXXFLAGS,$(TARGET_SYSROOT_OPT) $(TARGET_CXXFLAGS))
	$(call QT_QMAKE_SET,LFLAGS,$(TARGET_LDFLAGS))
	-[ -f $(QT_QCONFIG_FILE) ] && cp $(QT_QCONFIG_FILE) \
		$(QT_TARGET_DIR)/$(QT_QCONFIG_FILE_LOCATION)
# Don't use TARGET_CONFIGURE_OPTS here, qmake would be compiled for the target
# instead of the host then. So set PKG_CONFIG* manually.
	(cd $(QT_TARGET_DIR); \
		PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)" \
		PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
		PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig:$(PKG_CONFIG_PATH)" \
		./configure \
		$(if $(VERBOSE),-verbose,-silent) \
		-force-pkg-config \
		-embedded $(BR2_PACKAGE_QT_EMB_PLATFORM) \
		$(QT_QCONFIG_COMMAND) \
		$(QT_CONFIGURE) \
		-no-gfx-qnx \
		-no-kbd-qnx \
		-no-mouse-qnx \
		-no-xinerama \
		-no-cups \
		-no-nis \
		-no-accessibility \
		-no-separate-debug-info \
		-prefix /usr \
		-hostprefix $(STAGING_DIR)/usr \
		-fast \
		-no-rpath \
	)
	touch $@

$(QT_TARGET_DIR)/.compiled: $(QT_TARGET_DIR)/.configured
	$(MAKE) -C $(QT_TARGET_DIR)
	touch $@

$(HOST_DIR)/usr/bin/qt.conf:
	mkdir -p $(dir $@)
	echo "[Paths]" > $@
	echo "Prefix=$(HOST_DIR)/usr" >> $@
	echo "Headers=$(STAGING_DIR)/usr/include" >> $@
	echo "Libraries=$(STAGING_DIR)/usr/lib" >> $@
	echo "Data=$(HOST_DIR)/usr" >> $@
	echo "Binaries=$(HOST_DIR)/usr/bin" >> $@

$(STAGING_DIR)/usr/lib/libQtCore.la: $(QT_TARGET_DIR)/.compiled $(HOST_DIR)/usr/bin/qt.conf
	$(MAKE) -C $(QT_TARGET_DIR) install
	# Move host programs and spec files to the host directory. The
	# generated qt.conf file will tell qmake where everything is.
	mv $(addprefix $(STAGING_DIR)/usr/bin/,moc rcc qmake lrelease) $(HOST_DIR)/usr/bin
ifeq ($(BR2_PACKAGE_QT_GUI_MODULE),y)
	mv $(STAGING_DIR)/usr/bin/uic $(HOST_DIR)/usr/bin
endif
	mv $(STAGING_DIR)/usr/mkspecs $(HOST_DIR)/usr

qt-gui: $(STAGING_DIR)/usr/lib/libQtCore.la
	mkdir -p $(TARGET_DIR)/usr/lib/fonts
ifneq ($(QT_FONTS),)
	cp -dpf $(QT_FONTS) $(TARGET_DIR)/usr/lib/fonts
endif
ifneq ($(BR2_PACKAGE_QT_NOFREETYPE),y)
	cp -dpf $(STAGING_DIR)/usr/lib/fonts/*.ttf $(TARGET_DIR)/usr/lib/fonts
endif
	# Install image plugins if they are built
	$(call QT_INSTALL_PLUGINS,imageformats)
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtGui.so.* $(TARGET_DIR)/usr/lib/
endif

qt-sql: $(STAGING_DIR)/usr/lib/libQtCore.la
	$(call QT_INSTALL_PLUGINS,sqldrivers)
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtSql.so.* $(TARGET_DIR)/usr/lib/
endif

qt-multimedia: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtMultimedia.so.* $(TARGET_DIR)/usr/lib/
endif

qt-phonon: $(STAGING_DIR)/usr/lib/libQtCore.la
	$(call QT_INSTALL_PLUGINS,phonon_backend)
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libphonon.so.* $(TARGET_DIR)/usr/lib/
endif

qt-svg: $(STAGING_DIR)/usr/lib/libQtCore.la
	$(call QT_INSTALL_PLUGINS,iconengines)
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtSvg.so.* $(TARGET_DIR)/usr/lib/
endif

qt-network: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtNetwork.so.* $(TARGET_DIR)/usr/lib/
endif

qt-webkit: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtWebKit.so.* $(TARGET_DIR)/usr/lib/
endif

qt-xml: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtXml.so.* $(TARGET_DIR)/usr/lib/
endif

qt-xmlpatterns: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtXmlPatterns.so.* $(TARGET_DIR)/usr/lib/
endif

qt-dbus: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtDBus.so.* $(TARGET_DIR)/usr/lib/
endif

qt-script: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtScript.so.* $(TARGET_DIR)/usr/lib/
endif

qt-scripttools: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtScriptTools.so.* $(TARGET_DIR)/usr/lib/
endif

qt-qt3support: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQt3Support.so.* $(TARGET_DIR)/usr/lib/
endif

$(TARGET_DIR)/usr/lib/libQtCore.so.4: $(STAGING_DIR)/usr/lib/libQtCore.la $(QT_LIBS)
	# Strip all installed libs
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtCore.so.* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libQt*.so.*
endif

qt: $(QT_DEP_LIBS) $(TARGET_DIR)/usr/lib/libQtCore.so.4

qt-clean:
	-$(MAKE) -C $(QT_TARGET_DIR) clean
	-rm -rf $(TARGET_DIR)/usr/lib/fonts
ifeq ($(BR2_PACKAGE_QT_SHARED),y)
	-rm $(TARGET_DIR)/usr/lib/libQt*.so.*
	-rm $(TARGET_DIR)/usr/lib/libphonon.so.*
endif

qt-dirclean:
	rm -rf $(QT_TARGET_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_QT),y)
TARGETS+=qt
endif
