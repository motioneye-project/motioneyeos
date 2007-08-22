######################################################################
#
# qtopia4 (Qtopia Core 4)
# http://www.trolltech.com/
#
# This makefile composed by Thomas Lundquist <thomasez@zelow.no>
#
# There is two versions built, one for the target and one for
# staging. The target version is built in the staging_dir and the
# staging version in the toolchain_dir.
#
# BTW, this uses alot of FPU calls and it's pretty slow if you use
# the kernels FPU emulation so it's better to choose soft float in the
# buildroot config (and uClibc.config of course, if you have your own.)
#
######################################################################

QTOPIA4_VERSION:=4.2.2
QTOPIA4_CAT:=$(ZCAT)

BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME:=$(strip $(subst ",, $(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME)))
#"))
BR2_PACKAGE_QTOPIA4_COMMERCIAL_PASSWORD:=$(strip $(subst ",, $(BR2_PACKAGE_QTOPIA4_COMMERCIAL_PASSWORD)))
#"))

# What to download, free or commercial version.
ifneq ($(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME),)

QTOPIA4_SITE:=http://$(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME):$(BR2_QTOPIA4_COMMERCIAL_PASSWORD)@dist.trolltech.com/$(BR2_PACKAGE_QTOPIA4_COMMERCIAL_USERNAME)
QTOPIA4_SOURCE:=qtopia-core-commercial-src-$(QTOPIA4_VERSION).tar.gz
QTOPIA4_TARGET_DIR:=$(BUILD_DIR)/qtopia-core-commercial-src-$(QTOPIA4_VERSION)
QTOPIA4_HOST_DIR:=$(TOOL_BUILD_DIR)/qtopia-core-commercial-src-$(QTOPIA4_VERSION)

else

# Good, good, we are free:

QTOPIA4_SITE=ftp://ftp.trolltech.com/qt/source/
QTOPIA4_SOURCE:=qtopia-core-opensource-src-$(QTOPIA4_VERSION).tar.gz
QTOPIA4_TARGET_DIR:=$(BUILD_DIR)/qtopia-core-opensource-src-$(QTOPIA4_VERSION)
QTOPIA4_HOST_DIR:=$(TOOL_BUILD_DIR)/qtopia-core-opensource-src-$(QTOPIA4_VERSION)

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

QTOPIA4_DEP_LIBS:=
ifeq ($(BR2_PACKAGE_JPEG),y)
QTOPIA4_DEP_LIBS+=jpeg
endif
ifeq ($(BR2_PACKAGE_LIBPNG),y)
QTOPIA4_DEP_LIBS+=libpng
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

ifeq ($(BR2_ENDIAN),"LITTLE")
QTOPIA4_ENDIAN=-little-endian
else
QTOPIA4_ENDIAN=-big-endian
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_DEPTHS),"")
QTOPIA4_DEPTHS=-depths 8
else
QTOPIA4_DEPTHS:=$(strip $(subst ",, $(BR2_PACKAGE_QTOPIA4_DEPTHS)))
#"))
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_GIF),y)
QTOPIA4_GIF_LIB=-qt-gif
else
QTOPIA4_GIF_LIB=-no-gif
endif

ifeq ($(BR2_PACKAGE_QTOPIA4_LIBMNG),y)
QTOPIA4_MNG_LIB=-qt-libmng
else
QTOPIA4_MNG_LIB=-no-libmng
endif

QTOPIA4_DEBUG:=$(strip $(subst ",, $(QTOPIA4_DEBUG)))
#"))
BR2_PACKAGE_QTOPIA4_EMB_PLATFORM:=$(strip $(subst ",, $(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)))
#"))


# Variable for other Qt applications to use
QTOPIA4_QMAKE:=$(QTOPIA4_HOST_DIR)/bin/qmake

$(DL_DIR)/$(QTOPIA4_SOURCE):
	 $(WGET) -P $(DL_DIR) $(QTOPIA4_SITE)/$(QTOPIA4_SOURCE)

qtopia4-source: $(DL_DIR)/$(QTOPIA4_SOURCE)

##############################################################################
#
# And now for the fun part, we have to do this in a two stage build because
# Qt saves the library path inside the binary libraries. I.e.
# libQtCore.so.<version> contains a hardcoded link to where the Qt libraries
# are installed. Therefor we have to do one build for host/staging where
# prefix is in our staging_dir, and a second build with prefix /usr for the
# target.
#
##############################################################################

#################################
#
# Target
#
#################################

$(QTOPIA4_TARGET_DIR)/.unpacked: $(DL_DIR)/$(QTOPIA4_SOURCE)
	$(QTOPIA4_CAT) $(DL_DIR)/$(QTOPIA4_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(QTOPIA4_TARGET_DIR) package/qtopia4/ \
		qtopia-$(QTOPIA4_VERSION)-\*.patch\*
	touch $@

# This configure is very tailored towards a specific need.
$(QTOPIA4_TARGET_DIR)/.configured: $(QTOPIA4_TARGET_DIR)/.unpacked
	# Patching configure to get rid of some features I don't want.
	# (I don't want SQL either but there is no option for that at all,
	# the SQL library will be built even without the plugins/drivers).
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
		CFLAGS="$(TARGET_CFLAGS)" \
		CXXFLAGS="$(TARGET_CXXFLAGS)" \
		QPEHOME=/usr \
		QPEDIR=/usr \
		./configure \
		-v \
		-platform linux-g++ \
		-embedded $(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM) \
		-xplatform qws/linux-$(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)-g++ \
		$(QTOPIA4_QCONFIG_COMMAND) \
		$(QTOPIA4_DEBUG) \
		$(QTOPIA4_DEPTHS) \
		-no-cups \
		-no-nis \
		-no-freetype \
		-no-accessibility \
		$(QTOPIA4_MNG_LIB) \
		$(QTOPIA4_GIF_LIB) \
		-no-sql-db2 \
		-no-sql-ibase \
		-no-sql-mysql \
		-no-sql-oci \
		-no-sql-odbc \
		-no-sql-psql \
		-no-sql-sqlite \
		-no-sql-sqlite2 \
		-no-sql-tds \
		-prefix /usr \
		-docdir /usr/share/qt4/doc \
		-headerdir /usr/include/qt4 \
		-datadir /usr/share/qt4 \
		-plugindir /usr/lib/qt4/plugins \
		-translationdir /usr/share/qt4/translations \
		-sysconfdir /etc/qt4 \
		-examplesdir /usr/share/qt4/examples \
		-demosdir /usr/share/qt4/demos \
		-nomake examples \
		-fast \
		-no-rpath \
		$(QTOPIA4_QT3SUPPORT) \
		$(QTOPIA4_TSLIB) \
		$(QTOPIA4_LARGEFILE) \
		$(QTOPIA4_ENDIAN) \
		$(QTOPIA4_APPROVE_GPL_LICENSE) \
	);
	touch $@

$(QTOPIA4_TARGET_DIR)/lib/libQtCore.so.$(QTOPIA4_VERSION): $(QTOPIA4_TARGET_DIR)/.configured
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(QTOPIA4_TARGET_DIR) sub-src

$(TARGET_DIR)/usr/lib/libQtCore.so.$(QTOPIA4_VERSION): $(QTOPIA4_TARGET_DIR)/lib/libQtCore.so.$(QTOPIA4_VERSION)
	mkdir -p $(TARGET_DIR)/usr/lib/fonts
	touch $(TARGET_DIR)/usr/lib/fonts/fontdir
	cp -dpf $(STAGING_DIR)/usr/lib/fonts/helvetica*.qpf $(TARGET_DIR)/usr/lib/fonts
	cp -dpf $(STAGING_DIR)/usr/lib/fonts/fixed*.qpf $(TARGET_DIR)/usr/lib/fonts
	cp -dpf $(STAGING_DIR)/usr/lib/fonts/micro*.qpf $(TARGET_DIR)/usr/lib/fonts
	cp -dpf $(QTOPIA4_TARGET_DIR)/lib/libQt*.so.* $(TARGET_DIR)/usr/lib/
	# Install image plugins if they are built
	if [ -d $(QTOPIA4_TARGET_DIR)/plugins/imageformats ]; then \
		mkdir -p $(TARGET_DIR)/usr/lib/qt4/plugins; \
		cp -dpfr $(QTOPIA4_TARGET_DIR)/plugins/imageformats $(TARGET_DIR)/usr/lib/qt4/plugins; \
		$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/qt4/plugins/imageformats/*; \
	fi
	# Remove Sql libraries, not needed
	-rm $(TARGET_DIR)/usr/lib/libQtSql*
	# Remove Svg libraries, not needed
	-rm $(TARGET_DIR)/usr/lib/libQtSvg*
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libQt*.so.$(QTOPIA4_VERSION)

#################################
#
# Host/Staging
#
#################################

$(QTOPIA4_HOST_DIR)/.unpacked: $(DL_DIR)/$(QTOPIA4_SOURCE)
	$(QTOPIA4_CAT) $(DL_DIR)/$(QTOPIA4_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(QTOPIA4_HOST_DIR) package/qtopia4/ \
		qtopia-$(QTOPIA4_VERSION)-\*.patch\*
	touch $@

# This configure is very tailored towards a specific need.
$(QTOPIA4_HOST_DIR)/.configured: $(QTOPIA4_HOST_DIR)/.unpacked
	# Patching configure to get rid of some feature I dont want.
	# (I don't want SQL either but there is no option for that at all,
	# the SQL library will be built even without the plugins/drivers).
ifneq ($(BR2_INET_IPV6),y)
	$(SED) 's/^CFG_IPV6=auto/CFG_IPV6=no/' $(QTOPIA4_HOST_DIR)/configure
	$(SED) 's/^CFG_IPV6IFNAME=auto/CFG_IPV6IFNAME=no/' $(QTOPIA4_HOST_DIR)/configure
endif
	$(SED) 's/^CFG_XINERAMA=auto/CFG_XINERAMA=no/' $(QTOPIA4_HOST_DIR)/configure
	$(SED) 's,-O2,$(TARGET_CFLAGS),' $(QTOPIA4_HOST_DIR)/mkspecs/qws/linux-$(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)-g++/qmake.conf
	-[ -f $(QTOPIA4_QCONFIG_FILE) ] && cp $(QTOPIA4_QCONFIG_FILE) \
		$(QTOPIA4_HOST_DIR)/$(QTOPIA4_QCONFIG_FILE_LOCATION)
	(cd $(QTOPIA4_HOST_DIR); rm -rf config.cache; \
		PATH=$(TARGET_PATH) \
		CFLAGS="$(TARGET_CFLAGS)" \
		CXXFLAGS="$(TARGET_CXXFLAGS)" \
		QPEHOME=/usr \
		QPEDIR=/usr \
		./configure \
		-v \
		-platform linux-g++ \
		-embedded $(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM) \
		-xplatform qws/linux-$(BR2_PACKAGE_QTOPIA4_EMB_PLATFORM)-g++ \
		$(QTOPIA4_QCONFIG_COMMAND) \
		$(QTOPIA4_DEBUG) \
		$(QTOPIA4_DEPTHS) \
		-no-cups \
		-no-nis \
		-no-freetype \
		-no-accessibility \
		$(QTOPIA4_MNG_LIB) \
		$(QTOPIA4_GIF_LIB) \
		-no-sql-db2 \
		-no-sql-ibase \
		-no-sql-mysql \
		-no-sql-oci \
		-no-sql-odbc \
		-no-sql-psql \
		-no-sql-sqlite \
		-no-sql-sqlite2 \
		-no-sql-tds \
		-prefix $(STAGING_DIR)/usr \
		-docdir $(STAGING_DIR)/usr/share/qt4/doc \
		-headerdir $(STAGING_DIR)/usr/include/qt4 \
		-datadir $(STAGING_DIR)/usr/share/qt4 \
		-plugindir $(STAGING_DIR)/usr/lib/qt4/plugins \
		-translationdir $(STAGING_DIR)/usr/share/qt4/translations \
		-sysconfdir $(STAGING_DIR)/etc/qt4 \
		-examplesdir $(STAGING_DIR)/usr/share/qt4/examples \
		-demosdir $(STAGING_DIR)/usr/share/qt4/demos \
		-nomake examples \
		-fast \
		-no-rpath \
		$(QTOPIA4_QT3SUPPORT) \
		$(QTOPIA4_TSLIB) \
		$(QTOPIA4_LARGEFILE) \
		$(QTOPIA4_ENDIAN) \
		$(QTOPIA4_APPROVE_GPL_LICENSE) \
	);
	touch $@

$(QTOPIA4_HOST_DIR)/lib/libQtCore.so.$(QTOPIA4_VERSION): $(QTOPIA4_HOST_DIR)/.configured
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(QTOPIA4_HOST_DIR)

$(STAGING_DIR)/usr/lib/libQtCore.so.$(QTOPIA4_VERSION): $(QTOPIA4_HOST_DIR)/lib/libQtCore.so.$(QTOPIA4_VERSION)
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(QTOPIA4_HOST_DIR) install

qtopia4: uclibc zlib $(QTOPIA4_DEP_LIBS) \
		$(STAGING_DIR)/usr/lib/libQtCore.so.$(QTOPIA4_VERSION) \
		$(TARGET_DIR)/usr/lib/libQtCore.so.$(QTOPIA4_VERSION)

qtopia4-clean:
	-$(MAKE) -C $(QTOPIA4_HOST_DIR) clean
	-$(MAKE) -C $(QTOPIA4_TARGET_DIR) clean

qtopia4-dirclean:
	rm -rf $(QTOPIA4_HOST_DIR)
	rm -rf $(QTOPIA4_TARGET_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_QTOPIA4)),y)
TARGETS+=qtopia4
endif
