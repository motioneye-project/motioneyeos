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

QTOPIA4_VERSION:=4.4.0-snapshot-20080312
QTOPIA4_CAT:=$(ZCAT)

BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME:=$(strip $(subst ",, $(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME)))
#"))
BR2_PACKAGE_QTOPIA4_COMMERCIAL_PASSWORD:=$(strip $(subst ",, $(BR2_PACKAGE_QTOPIA4_COMMERCIAL_PASSWORD)))
#"))

# What to download, free or commercial version.
ifneq ($(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME),)
QTOPIA4_SITE:=http://$(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME):$(BR2_QTOPIA4_COMMERCIAL_PASSWORD)@dist.trolltech.com/$(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME)
QTOPIA4_SOURCE:=qt-embedded-linux-commercial-src-$(QTOPIA4_VERSION).tar.gz
QTOPIA4_TARGET_DIR:=$(BUILD_DIR)/qt-embedded-linux-commercial-src-$(QTOPIA4_VERSION)
QTOPIA4_NO_SQL_OCI:=-no-sql-oci
QTOPIA4_NO_SQL_TDS:=-no-sql-tds
QTOPIA4_NO_SQL_DB2:=-no-sql-db2
else # Good, good, we are free:
QTOPIA4_SITE=ftp://ftp.trolltech.com/qt/snapshots
QTOPIA4_SOURCE:=qt-embedded-linux-opensource-src-$(QTOPIA4_VERSION).tar.gz
QTOPIA4_TARGET_DIR:=$(BUILD_DIR)/qt-embedded-linux-opensource-src-$(QTOPIA4_VERSION)
ifeq ($(BR2_PACKAGE_QTOPIA4_GPL_LICENSE_APPROVED),y)
QTOPIA4_APPROVE_GPL_LICENSE:=-confirm-license
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
QTOPIA4_LARGEFILE=-largefile
else
QTOPIA4_LARGEFILE=-no-largefile
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_QT3SUPPORT),y)
QTOPIA4_QT3SUPPORT=-qt3support
else
QTOPIA4_QT3SUPPORT=-no-qt3support
endif

ifeq ($(BR2_PACKAGE_TSLIB),y)
QTOPIA4_TSLIB=-qt-mouse-tslib
QTOPIA4_DEP_LIBS+=tslib
QTOPIA4_TSLIB_DEB="-D TSLIBMOUSEHANDLER_DEBUG"
QTOPIA4_TSLIB_DEB:=$(strip $(subst ",, $(QTOPIA4_TSLIB_DEB)))
#"))
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_DEBUG),y)
QTOPIA4_DEBUG="-debug $(QTOPIA4_TSLIB_DEB)"
else
QTOPIA4_DEBUG=-release
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_SHARED),y)
QTOPIA4_SHARED=-shared
else
QTOPIA4_SHARED=-static
endif

ifeq ($(BR2_ENDIAN),"LITTLE")
QTOPIA4_ENDIAN=-little-endian
else
QTOPIA4_ENDIAN=-big-endian
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_GIF),y)
QTOPIA4_GIF=-qt-gif
else
QTOPIA4_GIF=-no-gif
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_LIBMNG),y)
QTOPIA4_MNG=-qt-libmng
else
QTOPIA4_MNG=-no-libmng
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_QTZLIB),y)
QTOPIA4_ZLIB=-qt-zlib
else
ifeq ($(BR2_PACKAGE_QTOPIA4_SYSTEMZLIB),y)
QTOPIA4_ZLIB=-system-zlib
QTOPIA4_DEP_LIBS+=zlib
else
QTOPIA4_ZLIB=-no-zlib
endif
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_QTJPEG),y)
QTOPIA4_JPEG=-qt-libjpeg
else
ifeq ($(BR2_PACKAGE_QTOPIA4_SYSTEMJPEG),y)
QTOPIA4_JPEG=-system-libjpeg
QTOPIA4_DEP_LIBS+=jpeg
else
QTOPIA4_JPEG=-no-libjpeg
endif
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_QTPNG),y)
QTOPIA4_PNG=-qt-libpng
else
ifeq ($(BR2_PACKAGE_QTOPIA4_SYSTEMPNG),y)
QTOPIA4_PNG=-system-libpng
QTOPIA4_DEP_LIBS+=libpng
else
QTOPIA4_PNG=-no-libpng
endif
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_QTTIFF),y)
QTOPIA4_TIFF=-qt-libtiff
else
ifeq ($(BR2_PACKAGE_QTOPIA4_SYSTEMTIFF),y)
QTOPIA4_TIFF=-system-libtiff
QTOPIA4_DEP_LIBS+=tiff
else
QTOPIA4_TIFF=-no-libtiff
endif
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_OPENSSL),y)
QTOPIA4_OPENSSL=-openssl
QTOPIA4_DEP_LIBS+=openssl
else
QTOPIA4_OPENSSL=-no-openssl
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_SQL),y)
QTOPIA4_SQL_IBASE=-qt-sql-ibase
QTOPIA4_SQL_MYSQL=-qt-sql-mysql
QTOPIA4_SQL_ODBC=-qt-sql-odbc
QTOPIA4_SQL_PSQL=-qt-sql-psql
QTOPIA4_SQL_SQLITE=-qt-sql-sqlite
QTOPIA4_SQL_SQLITE2=-qt-sql-sqlite2
else
QTOPIA4_SQL_IBASE=-no-sql-ibase
QTOPIA4_SQL_MYSQL=-no-sql-mysql
QTOPIA4_SQL_ODBC=-no-sql-odbc
QTOPIA4_SQL_PSQL=-no-sql-psql
QTOPIA4_SQL_SQLITE=-no-sql-sqlite
QTOPIA4_SQL_SQLITE2=-no-sql-sqlite2
endif

QTOPIA4_DEBUG:=$(strip $(subst ",, $(QTOPIA4_DEBUG)))
#"))
BR2_PACKAGE_QTOPIA4_EMB_PLATFORM:=$(strip $(subst ",, $(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)))
#"))


# Variable for other Qt applications to use
QTOPIA4_QMAKE:=$(STAGING_DIR)/usr/bin/qmake

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
	$(SED) 's,-O2,$(TARGET_CFLAGS),' $(QTOPIA4_TARGET_DIR)/mkspecs/qws/linux-$(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)-g++/qmake.conf
	-[ -f $(QTOPIA4_QCONFIG_FILE) ] && cp $(QTOPIA4_QCONFIG_FILE) \
		$(QTOPIA4_TARGET_DIR)/$(QTOPIA4_QCONFIG_FILE_LOCATION)
	(cd $(QTOPIA4_TARGET_DIR); rm -rf config.cache; \
		PATH=$(TARGET_PATH) \
		./configure \
		-verbose \
		-embedded $(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM) \
		$(QTOPIA4_QCONFIG_COMMAND) \
		$(QTOPIA4_DEBUG) \
		$(QTOPIA4_SHARED) \
		-no-stl \
		-no-cups \
		-no-nis \
		-no-freetype \
		-no-accessibility \
		$(QTOPIA4_MNG) \
		$(QTOPIA4_GIF) \
		$(QTOPIA4_JPEG) \
		$(QTOPIA4_PNG) \
		$(QTOPIA4_TIFF) \
		$(QTOPIA4_ZLIB) \
		$(QTOPIA4_SQL_IBASE) \
		$(QTOPIA4_SQL_MYSQL) \
		$(QTOPIA4_SQL_ODBC) \
		$(QTOPIA4_SQL_PSQL) \
		$(QTOPIA4_SQL_SQLITE) \
		$(QTOPIA4_SQL_SQLITE2) \
		$(QTOPIA4_NO_SQL_DB2) \
		$(QTOPIA4_NO_SQL_OCI) \
		$(QTOPIA4_NO_SQL_TDS) \
		-no-webkit \
		-no-separate-debug-info \
		-prefix /usr \
		-hostprefix $(STAGING_DIR)/usr \
		-fast \
		-no-rpath \
		-nomake examples \
		-nomake demos \
		$(QTOPIA4_QT3SUPPORT) \
		$(QTOPIA4_TSLIB) \
		$(QTOPIA4_LARGEFILE) \
		$(QTOPIA4_ENDIAN) \
		$(QTOPIA4_APPROVE_GPL_LICENSE) \
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
	-$(STRIPCMD) --strip-unneeded $(TARGET_DIR)/usr/lib/libQt*.so.*
endif
	# Install image plugins if they are built
	if [ -d $(STAGING_DIR)/usr/plugins/imageformats ]; then \
		mkdir -p $(TARGET_DIR)/usr/plugins; \
		cp -dpfr $(STAGING_DIR)/usr/plugins/imageformats $(TARGET_DIR)/usr/plugins/; \
		$(STRIPCMD) --strip-unneeded $(TARGET_DIR)/usr/plugins/imageformats/*; \
	fi
ifneq ($(BR2_PACKAGE_QTOPIA4_SQL),y)
	# Remove Sql libraries, not needed
	-rm $(TARGET_DIR)/usr/lib/libQtSql*
endif
	# Remove Svg libraries, not needed
	-rm $(TARGET_DIR)/usr/lib/libQtSvg*

qtopia4: uclibc zlib $(QTOPIA4_DEP_LIBS) $(TARGET_DIR)/usr/lib/libQtCore.so.4

qtopia4-clean:
	-$(MAKE) -C $(QTOPIA4_TARGET_DIR) clean

qtopia4-dirclean:
	rm -rf $(QTOPIA4_TARGET_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_QTOPIA4)),y)
TARGETS+=qtopia4
endif
