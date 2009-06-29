######################################################################
#
# qtopia4 (Qt Embedded for Linux 4.5)
# http://www.qtsoftware.com/
#
# This makefile was oiginaly composed by Thomas Lundquist <thomasez@zelow.no>
# Later heavily modified by buildroot developers
#
# BTW, this uses alot of FPU calls and it's pretty slow if you use
# the kernels FPU emulation so it's better to choose soft float in the
# buildroot config (and uClibc.config of course, if you have your own.)
#
######################################################################

# BUG: In "OpenSuSE 10.2", dbus.h is at dbus-1.0/dbus/dbus.h
# instead of at "dbus/dbus.h"
# (cd /usr/include; sudo ln -s dbus-1.0/dbus dbus)
# to fix

# BUG: There is a workaround below (search for x86x86fix) for
# x86 crosscompiling under linux x86. Please remove it when the workaround
# is no longer necessary.

QTOPIA4_VERSION:=4.5.1
QTOPIA4_CAT:=$(BZCAT)

BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME:=$(strip $(subst ",, $(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME)))
#"))
BR2_PACKAGE_QTOPIA4_COMMERCIAL_PASSWORD:=$(strip $(subst ",, $(BR2_PACKAGE_QTOPIA4_COMMERCIAL_PASSWORD)))
#"))

QTOPIA4_CONFIGURE:=#empty

# What to download, free or commercial version.
ifneq ($(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME),)
QTOPIA4_SITE:=http://$(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME):$(BR2_QTOPIA4_COMMERCIAL_PASSWORD)@dist.trolltech.com/$(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME)
QTOPIA4_SOURCE:=qt-embedded-linux-commercial-src-$(QTOPIA4_VERSION).tar.bz2
QTOPIA4_TARGET_DIR:=$(BUILD_DIR)/qt-embedded-linux-commercial-src-$(QTOPIA4_VERSION)
QTOPIA4_CONFIGURE+= -commercial
else # Good, good, we are free:
QTOPIA4_SITE=http://get.qtsoftware.com/qt/source
QTOPIA4_SOURCE:=qt-embedded-linux-opensource-src-$(QTOPIA4_VERSION).tar.bz2
QTOPIA4_TARGET_DIR:=$(BUILD_DIR)/qt-embedded-linux-opensource-src-$(QTOPIA4_VERSION)
QTOPIA4_CONFIGURE+= -opensource
ifeq ($(BR2_PACKAGE_QTOPIA4_LICENSE_APPROVED),y)
QTOPIA4_CONFIGURE+= -confirm-license
endif
endif

# If you want extra tweaking you can copy
# $(QTOPIA4_TARGET_DIR)/src/corelib/global/qconfig-myfile.h
# to the qtopia4 packages directory (where this .mk file is) and
# remove the comment.
# QTOPIA4_QCONFIG_COMMAND:=-qconfig myfile
#
# For the options you can set in this file, look at
# $(QTOPIA4_TARGET_DIR)/src/corelib/global/qfeatures.txt
#
QTOPIA4_QCONFIG_FILE:=package/qtopia4/qconfig-myfile.h
QTOPIA4_QCONFIG_FILE_LOCATION:=/src/corelib/global/

ifeq ($(BR2_LARGEFILE),y)
QTOPIA4_CONFIGURE+= -largefile
else
QTOPIA4_CONFIGURE+= -no-largefile
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_QT3SUPPORT),y)
QTOPIA4_CONFIGURE+= -qt3support
else
QTOPIA4_CONFIGURE+= -no-qt3support
endif


### Pixel depths
ifeq ($(BR2_PACKAGE_QTOPIA4_PIXEL_DEPTH_ALL),y)
QTOPIA4_PIXEL_DEPTHS = all
else
ifeq ($(BR2_PACKAGE_QTOPIA4_PIXEL_DEPTH_1),y)
QTOPIA4_PIXEL_DEPTHS += 1
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_PIXEL_DEPTH_4),y)
QTOPIA4_PIXEL_DEPTHS += 4
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_PIXEL_DEPTH_8),y)
QTOPIA4_PIXEL_DEPTHS += 8
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_PIXEL_DEPTH_12),y)
QTOPIA4_PIXEL_DEPTHS += 12
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_PIXEL_DEPTH_15),y)
QTOPIA4_PIXEL_DEPTHS += 15
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_PIXEL_DEPTH_16),y)
QTOPIA4_PIXEL_DEPTHS += 16
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_PIXEL_DEPTH_18),y)
QTOPIA4_PIXEL_DEPTHS += 18
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_PIXEL_DEPTH_24),y)
QTOPIA4_PIXEL_DEPTHS += 24
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_PIXEL_DEPTH_32),y)
QTOPIA4_PIXEL_DEPTHS += 32
endif
endif
ifneq ($(QTOPIA4_PIXEL_DEPTHS),)
QTOPIA4_CONFIGURE += -depths $(subst $(space),$(comma),$(strip $(QTOPIA4_PIXEL_DEPTHS)))
endif

### Display drivers
ifeq ($(BR2_PACKAGE_QTOPIA4_GFX_LINUXFB),y)
QTOPIA4_CONFIGURE += -qt-gfx-linuxfb
else
QTOPIA4_CONFIGURE += -no-gfx-linuxfb
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_GFX_TRANSFORMED),y)
QTOPIA4_CONFIGURE += -qt-gfx-transformed
else
QTOPIA4_CONFIGURE += -no-gfx-transformed
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_GFX_QVFB),y)
QTOPIA4_CONFIGURE += -qt-gfx-qvfb
else
QTOPIA4_CONFIGURE += -no-gfx-qvfb
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_GFX_VNC),y)
QTOPIA4_CONFIGURE += -qt-gfx-vnc
else
QTOPIA4_CONFIGURE += -no-gfx-vnc
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_GFX_MULTISCREEN),y)
QTOPIA4_CONFIGURE += -qt-gfx-multiscreen
else
QTOPIA4_CONFIGURE += -no-gfx-multiscreen
endif

### Mouse drivers
ifeq ($(BR2_PACKAGE_QTOPIA4_MOUSE_PC),y)
QTOPIA4_CONFIGURE += -qt-mouse-pc
else
QTOPIA4_CONFIGURE += -no-mouse-pc
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_MOUSE_BUS),y)
QTOPIA4_CONFIGURE += -qt-mouse-bus
else
QTOPIA4_CONFIGURE += -no-mouse-bus
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_MOUSE_LINUXTP),y)
QTOPIA4_CONFIGURE += -qt-mouse-linuxtp
else
QTOPIA4_CONFIGURE += -no-mouse-linuxtp
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_MOUSE_YOPY),y)
QTOPIA4_CONFIGURE += -qt-mouse-yopy
else
QTOPIA4_CONFIGURE += -no-mouse-yopy
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_MOUSE_VR41XX),y)
QTOPIA4_CONFIGURE += -qt-mouse-vr41xx
else
QTOPIA4_CONFIGURE += -no-mouse-vr41xx
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_MOUSE_TSLIB),y)
QTOPIA4_CONFIGURE += -qt-mouse-tslib
QTOPIA4_DEP_LIBS+=tslib
QTOPIA4_TSLIB_DEB="-D TSLIBMOUSEHANDLER_DEBUG"
QTOPIA4_TSLIB_DEB:=$(strip $(subst ",, $(QTOPIA4_TSLIB_DEB)))
#"))
else
QTOPIA4_CONFIGURE += -no-mouse-tslib
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_MOUSE_QVFB),y)
QTOPIA4_CONFIGURE += -qt-mouse-qvfb
else
QTOPIA4_CONFIGURE += -no-mouse-qvfb
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_DEBUG),y)
QTOPIA4_CONFIGURE+= "-debug $(QTOPIA4_TSLIB_DEB)"
else
QTOPIA4_CONFIGURE+= -release
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
QTOPIA4_CONFIGURE+= -shared
else
QTOPIA4_CONFIGURE+= -static
endif

ifeq ($(BR2_ENDIAN),"LITTLE")
QTOPIA4_CONFIGURE+= -little-endian
else
QTOPIA4_CONFIGURE+= -big-endian
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_GIF),y)
QTOPIA4_CONFIGURE+= -qt-gif
else
QTOPIA4_CONFIGURE+= -no-gif
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_LIBMNG),y)
QTOPIA4_CONFIGURE+= -qt-libmng
else
QTOPIA4_CONFIGURE+= -no-libmng
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_QTZLIB),y)
QTOPIA4_CONFIGURE+= -qt-zlib
else
ifeq ($(BR2_PACKAGE_QTOPIA4_SYSTEMZLIB),y)
QTOPIA4_CONFIGURE+= -system-zlib
QTOPIA4_DEP_LIBS+=zlib
endif
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_QTJPEG),y)
QTOPIA4_CONFIGURE+= -qt-libjpeg
else
ifeq ($(BR2_PACKAGE_QTOPIA4_SYSTEMJPEG),y)
QTOPIA4_CONFIGURE+= -system-libjpeg
QTOPIA4_DEP_LIBS+=jpeg
else
QTOPIA4_CONFIGURE+= -no-libjpeg
endif
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_QTPNG),y)
QTOPIA4_CONFIGURE+= -qt-libpng
else
ifeq ($(BR2_PACKAGE_QTOPIA4_SYSTEMPNG),y)
QTOPIA4_CONFIGURE+= -system-libpng
QTOPIA4_DEP_LIBS+=libpng
else
QTOPIA4_CONFIGURE+= -no-libpng
endif
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_QTTIFF),y)
QTOPIA4_CONFIGURE+= -qt-libtiff
else
ifeq ($(BR2_PACKAGE_QTOPIA4_SYSTEMTIFF),y)
QTOPIA4_CONFIGURE+= -system-libtiff
QTOPIA4_DEP_LIBS+=tiff
else
QTOPIA4_CONFIGURE+= -no-libtiff
endif
endif


ifeq ($(BR2_PACKAGE_QTOPIA4_QTFREETYPE),y)
QTOPIA4_CONFIGURE+= -qt-freetype
else
ifeq ($(BR2_PACKAGE_QTOPIA4_SYSTEMFREETYPE),y)
QTOPIA4_CONFIGURE+= -system-freetype
QTOPIA4_CONFIGURE+= -I $(STAGING_DIR)/usr/include/freetype2/
QTOPIA4_DEP_LIBS+=freetype
else
QTOPIA4_CONFIGURE+= -no-freetype
endif
endif


ifeq ($(BR2_PACKAGE_QTOPIA4_OPENSSL),y)
QTOPIA4_CONFIGURE+= -openssl
QTOPIA4_DEP_LIBS+=openssl
else
QTOPIA4_CONFIGURE+= -no-openssl
endif

# Qt SQL Drivers
ifeq ($(BR2_PACKAGE_QTOPIA4_SQL_MODULE),y)
ifeq ($(BR2_PACKAGE_QTOPIA4_IBASE),y)
QTOPIA4_CONFIGURE+= -qt-sql-ibase
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_MYSQL),y)
QTOPIA4_CONFIGURE+= -qt-sql-mysql
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_ODBC),y)
QTOPIA4_CONFIGURE+= -qt-sql-odbc
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_PSQL),y)
QTOPIA4_CONFIGURE+= -qt-sql-psql
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_SQLITE),y)
QTOPIA4_CONFIGURE+= -qt-sql-sqlite
else
QTOPIA4_CONFIGURE+= -no-sql-sqlite
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_SQLITE2),y)
QTOPIA4_CONFIGURE+= -qt-sql-sqlite2
endif
else
# By default, no SQL driver is turned on by configure.
# but it seams sqlite isn't disabled despite what says
# configure --help
QTOPIA4_CONFIGURE+= -no-sql-sqlite
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_XMLPATTERNS),y)
QTOPIA4_CONFIGURE+= -xmlpatterns -exceptions
else
QTOPIA4_CONFIGURE+= -no-xmlpatterns
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_PHONON),y)
QTOPIA4_CONFIGURE+= -phonon
QTOPIA4_DEP_LIBS+=gstreamer gst-plugins-base
else
QTOPIA4_CONFIGURE+= -no-phonon
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_SVG),y)
QTOPIA4_CONFIGURE+= -svg
else
QTOPIA4_CONFIGURE+= -no-svg
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_WEBKIT),y)
QTOPIA4_CONFIGURE+= -webkit
else
QTOPIA4_CONFIGURE+= -no-webkit
endif

QTOPIA4_CONFIGURE:=$(strip $(subst ",, $(QTOPIA4_CONFIGURE)))
#"))
BR2_PACKAGE_QTOPIA4_EMB_PLATFORM:=$(strip $(subst ",, $(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)))
#"))

# x86x86fix
# Workaround Qt Embedded bug when crosscompiling for x86 under x86 with linux
# host. It's unclear if this would happen on other hosts.
ifneq ($(findstring pc-linux,$(BR2_GNU_BUILD_SUFFIX)),)
ifeq ($(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM),x86)
QTOPIA4_CONFIGURE+= -platform linux-g++
QTOPIA4_CONFIGURE:=$(strip $(subst ",, $(QTOPIA4_CONFIGURE)))
#"))
endif
endif
# End of workaround.

# Figure out what libs to install in the target
QTOPIA4_LIBS=#empty
ifeq ($(BR2_PACKAGE_QTOPIA4_GUI_MODULE),y)
QTOPIA4_LIBS+= qtopia4-gui  
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_SQL_MODULE),y)
QTOPIA4_LIBS+= qtopia4-sql
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_PHONON),y)
QTOPIA4_LIBS+= qtopia4-phonon
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_SVG),y)
QTOPIA4_LIBS+= qtopia4-svg
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_NETWORK),y)
QTOPIA4_LIBS+= qtopia4-network
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_WEBKIT),y)
QTOPIA4_LIBS+= qtopia4-webkit
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_XML),y)
QTOPIA4_LIBS+= qtopia4-xml
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_XMLPATTERNS),y)
QTOPIA4_LIBS+= qtopia4-xmlpatterns
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_SCRIPT),y)
QTOPIA4_LIBS+= qtopia4-script
endif
ifeq ($(BR2_PACKAGE_QTOPIA4_SCRIPTTOOLS),y)
QTOPIA4_LIBS+= qtopia4-scripttools
endif

QTOPIA4_QMAKE_CONF:=$(QTOPIA4_TARGET_DIR)/mkspecs/qws/linux-$(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)-g++/qmake.conf

QTOPIA4_QMAKE_AR:=$(TARGET_AR) cqs

# Variable for other Qt applications to use
QTOPIA4_QMAKE:=$(STAGING_DIR)/usr/bin/qmake -spec qws/linux-$(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)-g++

################################################################################
# QTOPIA4_QMAKE_SET -- helper macro to set QMAKE_<variable> = <value> in
# QTOPIA_QMAKE_CONF. Will remove existing variable declaration if available.
#
# Argument 1 is the variable name (without QMAKE_)
# Argument 2 is the value to set variable to
#
# E.G. use like this:
# $(call QTOPIA4_QMAKE_SET,variable,value)
################################################################################
define QTOPIA4_QMAKE_SET
	$(SED) '/QMAKE_$(1)/d' $(QTOPIA4_QMAKE_CONF)
	$(SED) '/include.*qws.conf/aQMAKE_$(1) = $(2)' $(QTOPIA4_QMAKE_CONF)
endef

################################################################################
# QTOPIA4_INSTALL_PLUGINS -- helper macro to install Qt plugins to target and 
# strip them
#
# Argument 1 is the plugin folder
# 
# E.G. use like this to install plugins/sqldrivers:
# $(call QTOPIA4_INSTALL_PLUGINS,sqldrivers)
# ################################################################################
define QTOPIA4_INSTALL_PLUGINS
        if [ -d $(STAGING_DIR)/usr/plugins/$(1) ]; then \
                mkdir -p $(TARGET_DIR)/usr/plugins; \
                cp -dpfr $(STAGING_DIR)/usr/plugins/$(1) $(TARGET_DIR)/usr/plugins/; \
                $(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/plugins/$(1)/*; \
        fi
endef

$(DL_DIR)/$(QTOPIA4_SOURCE):
	$(call DOWNLOAD,$(QTOPIA4_SITE),$(QTOPIA4_SOURCE))

qtopia4-source: $(DL_DIR)/$(QTOPIA4_SOURCE)


$(QTOPIA4_TARGET_DIR)/.unpacked: $(DL_DIR)/$(QTOPIA4_SOURCE)
	$(QTOPIA4_CAT) $(DL_DIR)/$(QTOPIA4_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(QTOPIA4_TARGET_DIR) package/qtopia4/ \
		qtopia-$(QTOPIA4_VERSION)-\*.patch \
		qtopia-$(QTOPIA4_VERSION)-\*.patch.$(ARCH)
	touch $@

$(QTOPIA4_TARGET_DIR)/.configured: $(QTOPIA4_TARGET_DIR)/.unpacked
ifneq ($(BR2_INET_IPV6),y)
	$(SED) 's/^CFG_IPV6=auto/CFG_IPV6=no/' $(QTOPIA4_TARGET_DIR)/configure
	$(SED) 's/^CFG_IPV6IFNAME=auto/CFG_IPV6IFNAME=no/' $(QTOPIA4_TARGET_DIR)/configure
endif
	$(SED) 's/^CFG_XINERAMA=auto/CFG_XINERAMA=no/' $(QTOPIA4_TARGET_DIR)/configure
	# Fix compiler path
	$(call QTOPIA4_QMAKE_SET,CC,$(TARGET_CC))
	$(call QTOPIA4_QMAKE_SET,CXX,$(TARGET_CXX))
	$(call QTOPIA4_QMAKE_SET,LINK,$(TARGET_CXX))
	$(call QTOPIA4_QMAKE_SET,LINK_SHLIB,$(TARGET_CXX))
	$(call QTOPIA4_QMAKE_SET,AR,$(QTOPIA4_QMAKE_AR))
	$(call QTOPIA4_QMAKE_SET,OBJCOPY,$(TARGET_OBJCOPY))
	$(call QTOPIA4_QMAKE_SET,RANLIB,$(TARGET_RANLIB))
	$(call QTOPIA4_QMAKE_SET,STRIP,$(TARGET_STRIP))
	-[ -f $(QTOPIA4_QCONFIG_FILE) ] && cp $(QTOPIA4_QCONFIG_FILE) \
		$(QTOPIA4_TARGET_DIR)/$(QTOPIA4_QCONFIG_FILE_LOCATION)
# Qt doesn't use PKG_CONFIG, it searches for pkg-config with 'which'.
# PKG_CONFIG_SYSROOT is only used to avoid a warning from Qt's configure system
# when cross compiling, Qt 4.4.3 is wrong here.
# Don't use TARGET_CONFIGURE_OPTS here, qmake would be compiled for the target
# instead of the host then.
	(cd $(QTOPIA4_TARGET_DIR); rm -rf config.cache; \
		PATH=$(TARGET_PATH) \
		PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)" \
		PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig:$(PKG_CONFIG_PATH)" \
		PKG_CONFIG_SYSROOT="$(STAGING_DIR)" \
		./configure \
		$(if $(VERBOSE),-verbose,-silent) \
		-force-pkg-config \
		-embedded $(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM) \
		$(QTOPIA4_QCONFIG_COMMAND) \
		$(QTOPIA4_CONFIGURE) \
		-no-stl \
		-no-cups \
		-no-nis \
		-no-accessibility \
		-no-separate-debug-info \
		-prefix /usr \
		-hostprefix $(STAGING_DIR)/usr \
		-fast \
		-no-rpath \
		-nomake examples \
		-nomake demos \
	)
	touch $@

$(QTOPIA4_TARGET_DIR)/.compiled: $(QTOPIA4_TARGET_DIR)/.configured
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(QTOPIA4_TARGET_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/libQtCore.la: $(QTOPIA4_TARGET_DIR)/.compiled
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(QTOPIA4_TARGET_DIR) install

qtopia4-gui: $(STAGING_DIR)/usr/lib/libQtCore.la
	mkdir -p $(TARGET_DIR)/usr/lib/fonts
	touch $(TARGET_DIR)/usr/lib/fonts/fontdir
	cp -dpf $(STAGING_DIR)/usr/lib/fonts/helvetica*.qpf $(TARGET_DIR)/usr/lib/fonts
	cp -dpf $(STAGING_DIR)/usr/lib/fonts/fixed*.qpf $(TARGET_DIR)/usr/lib/fonts
	cp -dpf $(STAGING_DIR)/usr/lib/fonts/micro*.qpf $(TARGET_DIR)/usr/lib/fonts
	# Install image plugins if they are built
	$(call QTOPIA4_INSTALL_PLUGINS,imageformats)
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtGui.so.* $(TARGET_DIR)/usr/lib/
endif

qtopia4-sql: $(STAGING_DIR)/usr/lib/libQtCore.la
	$(call QTOPIA4_INSTALL_PLUGINS,sqldrivers)
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtSql.so.* $(TARGET_DIR)/usr/lib/
endif

qtopia4-phonon: $(STAGING_DIR)/usr/lib/libQtCore.la
	$(call QTOPIA4_INSTALL_PLUGINS,phonon_backend)
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libphonon.so.* $(TARGET_DIR)/usr/lib/
endif

qtopia4-svg: $(STAGING_DIR)/usr/lib/libQtCore.la
	$(call QTOPIA4_INSTALL_PLUGINS,iconengines)
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtSvg.so.* $(TARGET_DIR)/usr/lib/
endif

qtopia4-network: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtNetwork.so.* $(TARGET_DIR)/usr/lib/
endif

qtopia4-webkit: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtWebKit.so.* $(TARGET_DIR)/usr/lib/
endif

qtopia4-xml: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtXml.so.* $(TARGET_DIR)/usr/lib/
endif

qtopia4-xmlpatterns: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtXmlPatterns.so.* $(TARGET_DIR)/usr/lib/
endif

qtopia4-script: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtScript.so.* $(TARGET_DIR)/usr/lib/
endif

qtopia4-scripttools: $(STAGING_DIR)/usr/lib/libQtCore.la
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtScriptTools.so.* $(TARGET_DIR)/usr/lib/
endif


$(TARGET_DIR)/usr/lib/libQtCore.so.4: $(STAGING_DIR)/usr/lib/libQtCore.la $(QTOPIA4_LIBS)
	# Strip all installed libs
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQtCore.so.* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libQt*.so.*
endif

qtopia4: uclibc $(QTOPIA4_DEP_LIBS) $(TARGET_DIR)/usr/lib/libQtCore.so.4

qtopia4-clean:
	-$(MAKE) -C $(QTOPIA4_TARGET_DIR) clean
	-rm -rf $(TARGET_DIR)/usr/lib/fonts
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	-rm $(TARGET_DIR)/usr/lib/libQt*.so.*
	-rm $(TARGET_DIR)/usr/lib/libphonon.so.*
endif

qtopia4-dirclean:
	rm -rf $(QTOPIA4_TARGET_DIR)

qtopia4-status:
	@echo "QTOPIA4_QMAKE:               " $(QTOPIA4_QMAKE)
	@echo "QTOPIA4_DEP_LIBS:            " $(QTOPIA4_DEP_LIBS)
	@echo "FREETYPE_DIR:		    " $(FREETYPE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_QTOPIA4),y)
TARGETS+=qtopia4
endif
