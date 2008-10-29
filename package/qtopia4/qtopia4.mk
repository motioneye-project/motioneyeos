######################################################################
#
# qtopia4 (Qtopia Core 4)
# http://www.trolltech.com/
#
# This makefile composed by Thomas Lundquist <thomasez@zelow.no>
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

QTOPIA4_VERSION:=4.4.3
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
QTOPIA4_CONFIGURE+= -no-sql-oci -no-sql-tds -no-sql-db2
else # Good, good, we are free:
QTOPIA4_SITE=ftp://ftp.trolltech.com/qt/source
QTOPIA4_SOURCE:=qt-embedded-linux-opensource-src-$(QTOPIA4_VERSION).tar.bz2
QTOPIA4_TARGET_DIR:=$(BUILD_DIR)/qt-embedded-linux-opensource-src-$(QTOPIA4_VERSION)
ifeq ($(BR2_PACKAGE_QTOPIA4_GPL_LICENSE_APPROVED),y)
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

ifeq ($(BR2_PACKAGE_TSLIB),y)
QTOPIA4_CONFIGURE+= -qt-mouse-tslib
QTOPIA4_DEP_LIBS+=tslib
QTOPIA4_TSLIB_DEB="-D TSLIBMOUSEHANDLER_DEBUG"
QTOPIA4_TSLIB_DEB:=$(strip $(subst ",, $(QTOPIA4_TSLIB_DEB)))
#"))
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
QTOPIA4_CONFIGURE+= -I $(FREETYPE_DIR)/include
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
QTOPIA4_CONFIGURE+= -xmlpatterns
else
QTOPIA4_CONFIGURE+= -no-xmlpatterns
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

QTOPIA4_QMAKE_CONF:=$(QTOPIA4_TARGET_DIR)/mkspecs/qws/linux-$(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)-g++/qmake.conf

# Variable for other Qt applications to use
QTOPIA4_QMAKE:=$(STAGING_DIR)/usr/bin/qmake -spec qws/linux-$(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)-g++

$(DL_DIR)/$(QTOPIA4_SOURCE):
	$(WGET) -P $(DL_DIR) $(QTOPIA4_SITE)/$(QTOPIA4_SOURCE)

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
	#$(SED) 's,-O2,$(TARGET_CFLAGS),' $(QTOPIA4_TARGET_DIR)/mkspecs/qws/linux-$(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)-g++/qmake.conf
        # Fix compiler path
	$(SED) '\,QMAKE_CC[ 	]*=, c\QMAKE_CC = $(TARGET_CC)' $(QTOPIA4_QMAKE_CONF)
	$(SED) '\,QMAKE_CXX[ 	]*=, c\QMAKE_CXX = $(TARGET_CXX)' $(QTOPIA4_QMAKE_CONF)
	$(SED) '\,QMAKE_LINK[ 	]*=, c\QMAKE_LINK = $(TARGET_CXX)' $(QTOPIA4_QMAKE_CONF)
	$(SED) '\,QMAKE_LINK_SHLIB[ 	]*=, c\QMAKE_LINK_SHLIB = $(TARGET_CXX)' $(QTOPIA4_QMAKE_CONF)
	$(SED) '\,QMAKE_AR[ 	]*=, c\QMAKE_AR = $(TARGET_AR) cqs' $(QTOPIA4_QMAKE_CONF)
	$(SED) '\,QMAKE_RANLIB[ 	]*=, c\QMAKE_RANLIB = $(TARGET_RANLIB)' $(QTOPIA4_QMAKE_CONF)
	$(SED) '\,QMAKE_STRIP[ 	]*=, c\QMAKE_STRIP = $(TARGET_STRIP)' $(QTOPIA4_QMAKE_CONF)

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
		-verbose \
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

$(TARGET_DIR)/usr/lib/libQtCore.so.4: $(STAGING_DIR)/usr/lib/libQtCore.la
	mkdir -p $(TARGET_DIR)/usr/lib/fonts
	touch $(TARGET_DIR)/usr/lib/fonts/fontdir
	cp -dpf $(STAGING_DIR)/usr/lib/fonts/helvetica*.qpf $(TARGET_DIR)/usr/lib/fonts
	cp -dpf $(STAGING_DIR)/usr/lib/fonts/fixed*.qpf $(TARGET_DIR)/usr/lib/fonts
	cp -dpf $(STAGING_DIR)/usr/lib/fonts/micro*.qpf $(TARGET_DIR)/usr/lib/fonts
ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
	cp -dpf $(STAGING_DIR)/usr/lib/libQt*.so.* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libQt*.so.*
endif
	# Install image plugins if they are built
	if [ -d $(STAGING_DIR)/usr/plugins/imageformats ]; then \
		mkdir -p $(TARGET_DIR)/usr/plugins; \
		cp -dpfr $(STAGING_DIR)/usr/plugins/imageformats $(TARGET_DIR)/usr/plugins/; \
		$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/plugins/imageformats/*; \
	fi
ifneq ($(BR2_PACKAGE_QTOPIA4_SQL),y)
	# Remove Sql libraries, not needed
	-rm $(TARGET_DIR)/usr/lib/libQtSql*
endif
ifneq ($(BR2_PACKAGE_QTOPIA4_SVG),y)
	# Remove Svg libraries, not needed
	-rm $(TARGET_DIR)/usr/lib/libQtSvg*
endif

qtopia4: uclibc zlib $(QTOPIA4_DEP_LIBS) $(TARGET_DIR)/usr/lib/libQtCore.so.4

qtopia4-clean:
	-$(MAKE) -C $(QTOPIA4_TARGET_DIR) clean

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
ifeq ($(strip $(BR2_PACKAGE_QTOPIA4)),y)
TARGETS+=qtopia4
endif
