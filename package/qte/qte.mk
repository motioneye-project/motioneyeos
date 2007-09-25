#############################################################
#
# qte: Qt/E build, includes Qt/E-2, QVfb, and Qtopia-2
#
#############################################################
ifeq ($(BR2_QTE_VERSION),)
BR2_QTE_VERSION:=FOOBAR1
endif
ifeq ($(BR2_QTE_QT3_VERSION),)
BR2_QTE_QT3_VERSION:=FOOBAR2
endif
ifeq ($(BR2_QTE_QVFB_VERSION),)
BR2_QTE_QVFB_VERSION:=FOOBAR3
endif
ifeq ($(BR2_QTE_QTOPIA_VERSION),)
BR2_QTE_QTOPIA_VERSION:=FOOBAR4
endif
ifeq ($(BR2_QTE_TMAKE_VERSION),)
BR2_QTE_TMAKE_VERSION:=FOOBAR5
endif

BR2_QTE_C_QTE_VERSION:=$(shell echo $(BR2_QTE_VERSION)| sed -e 's/"//g')
BR2_QTE_C_QT3_VERSION:=$(shell echo $(BR2_QTE_QT3_VERSION)| sed -e 's/"//g')
BR2_QTE_C_QVFB_VERSION:=$(shell echo $(BR2_QTE_QVFB_VERSION)| sed -e 's/"//g')
BR2_QTE_C_QTOPIA_VERSION:=$(shell echo $(BR2_QTE_QTOPIA_VERSION)| sed -e 's/"//g')
BR2_QTE_C_TMAKE_VERSION:=$(shell echo $(BR2_QTE_TMAKE_VERSION)| sed -e 's/"//g')
BR2_QTE_C_USERNAME:=$(shell echo $(BR2_PACKAGE_QTE_COMMERCIAL_USERNAME)| sed -e 's/"//g')
BR2_QTE_C_PASSWORD:=$(shell echo $(BR2_PACKAGE_QTE_COMMERCIAL_PASSWORD)| sed -e 's/"//g')
QTE_QTE_SOURCE:=qt-embedded-$(BR2_QTE_C_QTE_VERSION)-commercial.tar.gz
QTE_QT3_SOURCE:=qt-$(BR2_QTE_C_QT3_VERSION)-commercial.tar.gz
QTE_TMAKE_SOURCE:=tmake-$(BR2_QTE_C_TMAKE_VERSION).tar.gz
QTE_QVFB_SOURCE:=qt-x11-$(BR2_QTE_C_QVFB_VERSION)-commercial.tar.gz
QTE_QTOPIA_SOURCE:=qtopia-phone-source-$(BR2_QTE_C_QTOPIA_VERSION).tar.gz
QTE_SITE:=http://$(BR2_QTE_C_USERNAME):$(BR2_QTE_C_PASSWORD)@dist.trolltech.com/$(BR2_QTE_C_USERNAME)
QTE_QTE_DIR:=$(BUILD_DIR)/qt-$(BR2_QTE_C_QTE_VERSION)
QTE_QT3_DIR:=$(BUILD_DIR)/qt-$(BR2_QTE_C_QT3_VERSION)
QTE_TMAKE_DIR:=$(BUILD_DIR)/tmake-$(BR2_QTE_C_TMAKE_VERSION)
QTE_QVFB_DIR:=$(BUILD_DIR)/qt-$(BR2_QTE_C_QVFB_VERSION)
QTE_QTOPIA_DIR:=$(BUILD_DIR)/qtopia-phone-$(BR2_QTE_C_QTOPIA_VERSION)

QTE_CAT:=$(ZCAT)
TMAKE:=$(QTE_TMAKE_DIR)/bin/tmake
QTE_UIC_BINARY:=bin/uic
QTE_QVFB_BINARY:=bin/qvfb
QTE_QTE_LIB:=$(QTE_QTE_DIR)/lib/libqte-mt.so.$(BR2_QTE_C_QTE_VERSION)
#QTE_QTE_LIB:=$(TARGET_DIR)/lib/libqte-mt.so.$(BR2_QTE_C_QTE_VERSION)
QTE_QTOPIA_FILE:=$(QTE_QTOPIA_DIR)/bin/qpe
QTE_QTOPIA_IFILE:=$(QTE_QTOPIA_DIR)/opt/Qtopia/bin/qpe

#export QT2DIR=$(pwd)/qt-2.3.2
#export QT3DIR=$(pwd)/qt-%{qt_version}
#export QTEDIR=$(pwd)/qt-%{qte_version}
#export QPEDIR=$(pwd)

#############################################################
#
# Calculate configure options... scary eventually, trivial now
#
# currently only tested with threading
# FIXME: I should use the staging directory here, but I don't yet.
#
#############################################################
# I choose to make the link in libqte so that the linking later is trivial -- a user may choose to use -luuid, or not, and it'll just work.
# ...since libqte* needs -luuid anyhow...
QTE_QTE_CONFIGURE:=-no-xft -L$(E2FSPROGS_DIR)/lib -luuid
QTE_QVFB_CONFIGURE:=-no-xft
QTE_QTOPIA_CONFIGURE:=
QTE_QT3_CONFIGURE:=

ifeq ($(BR2_PTHREADS_NATIVE),y)
QTE_QTE_CONFIGURE:=$(QTE_QTE_CONFIGURE) -thread
QTE_QVFB_CONFIGURE:=$(QTE_QVFB_CONFIGURE) -thread
QTE_QTOPIA_CONFIGURE:=$(QTE_QTOPIA_CONFIGURE) -thread
QTE_QT3_CONFIGURE:=$(QTE_QT3_CONFIGURE) -thread
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
QTE_QTE_CONFIGURE:=$(QTE_QTE_CONFIGURE) -system-jpeg
#FIXME: Do I need an else on this?
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
QTE_QTE_CONFIGURE:=$(QTE_QTE_CONFIGURE) -system-libpng
else
QTE_QTE_CONFIGURE:=$(QTE_QTE_CONFIGURE) -qt-libpng
endif

# as of 2005-08-17's snapshot, uClibc's pthread does NOT support pthread_yield, which is needed
# for ffmpeg's qtopia-phone-2.1.1/src/3rdparty/plugins/codecs/libffmpeg/mediapacketbuffer.h:230
# (also called at line 232). ...so we have to disable ffmpeg
QTE_QTOPIA_CONFIGURE:=$(QTE_QTOPIA_CONFIGURE) -without-libffmpeg

QTE_QTOPIA_CONFIGURE:=$(QTE_QTOPIA_CONFIGURE) -L $(E2FSPROGS_DIR)/lib -I $(E2FSPROGS_DIR)/lib -luuid

#############################################################
#
# Build portion
#
#############################################################

ifneq ($(BR2_QTE_C_QTE_VERSION),$(BR2_QTE_C_QT3_VERSION))
$(DL_DIR)/$(QTE_QT3_SOURCE):
	$(WGET) -P $(DL_DIR) $(QTE_SITE)/$(@F)
endif

$(DL_DIR)/$(QTE_QTE_SOURCE) $(DL_DIR)/$(QTE_QVFB_SOURCE) $(DL_DIR)/$(QTE_QTOPIA_SOURCE):
	$(WGET) -P $(DL_DIR) $(QTE_SITE)/$(@F)

$(QTE_TMAKE_DIR)/.unpacked: $(DL_DIR)/$(QTE_TMAKE_SOURCE)
	$(QTE_CAT) $(DL_DIR)/$(QTE_TMAKE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

ifneq ($(BR2_QTE_C_QTE_VERSION),$(BR2_QTE_C_QT3_VERSION))
$(QTE_QT3_DIR)/.unpacked: $(DL_DIR)/$(QTE_QT3_SOURCE)
	$(QTE_CAT) $(DL_DIR)/$(QTE_QT3_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@
endif

$(QTE_QTE_DIR)/.unpacked: $(DL_DIR)/$(QTE_QTE_SOURCE)
	$(QTE_CAT) $(DL_DIR)/$(QTE_QTE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(QTE_QVFB_DIR)/.unpacked: $(DL_DIR)/$(QTE_QVFB_SOURCE)
	$(QTE_CAT) $(DL_DIR)/$(QTE_QVFB_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(QTE_QTOPIA_DIR)/.unpacked: $(DL_DIR)/$(QTE_QTOPIA_SOURCE)
	$(QTE_CAT) $(DL_DIR)/$(QTE_QTOPIA_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	# Allow patches -- copy from busybox usage of kernel patcher
	toolchain/patch-kernel.sh $(@D) package/qte qtopia-$(BR2_QTE_C_QTOPIA_VERSION)-\*.patch
	touch $@


# currently, this assumes that Qtopis is always involved. The dependency fails and the cp is wrong if Qtopis is not selected.
# I'll fix that later.
$(QTE_QTE_DIR)/.configured: $(QTE_QTE_DIR)/.unpacked $(QTE_TMAKE_DIR)/.unpacked $(QTE_QTE_DIR)/$(QTE_UIC_BINARY) $(QTE_QTE_DIR)/$(QTE_QVFB_BINARY) $(QTE_QTOPIA_DIR)/.unpacked
	cp $(QTE_QTOPIA_DIR)/src/qt/qconfig-qpe.h $(QTE_QTE_DIR)/src/tools/
	(cd $(@D); rm -f config.cache;  export QTDIR=`pwd`; export TMAKEPATH=$(QTE_TMAKE_DIR)/lib/qws/linux-x86-g++; export PATH=$(STAGING_DIR)/bin:$$QTDIR/bin:$$PATH; export LD_LIBRARY_PATH=$$QTDIR/lib:$$LD_LIBRARY_PATH; echo 'yes' | \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		$(QTE_QTE_CONFIGURE) -qconfig qpe -keypad-mode -qvfb -depths 4,8,16,32 -xplatform $(BR2_QTE_CROSS_PLATFORM) \
	)
	touch $@

ifneq ($(BR2_QTE_C_QTE_VERSION),$(BR2_QTE_C_QT3_VERSION))
# this is a host-side build, so we don't use any staging dir stuff, nor any TARGET_CONFIGURE_OPTS
$(QTE_QT3_DIR)/.configured: $(QTE_QT3_DIR)/.unpacked $(QTE_TMAKE_DIR)/.unpacked
	(cd $(@D); rm -f config.cache;  export QTDIR=`pwd`; export TMAKEPATH=$(QTE_TMAKE_DIR)/lib/qws/linux-x86-g++; export PATH=$$QTDIR/bin:$$PATH; export LD_LIBRARY_PATH=$$QTDIR/lib:$$LD_LIBRARY_PATH; echo 'yes' | \
		CC_FOR_BUILD="$(HOSTCC)" \
		./configure \
		-fast $(QTE_QT3_CONFIGURE) \
	)
	touch $@
endif

$(QTE_QVFB_DIR)/.configured: $(QTE_QVFB_DIR)/.unpacked $(QTE_TMAKE_DIR)/.unpacked
	(cd $(@D); rm -f config.cache;  export QTDIR=`pwd`; export TMAKEPATH=$(QTE_TMAKE_DIR)/lib/linux-g++; export $$QTDIR/bin:$$PATH; export LD_LIBRARY_PATH=$$QTDIR/lib:$$LD_LIBRARY_PATH; echo 'yes' | \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		$(QTE_QVFB_CONFIGURE) \
	)
	touch $@

# --edition {other}
# This has some kooky logic. Qtopia requires a Qt <= 3.3.0 to build, yet we like to use s Qt-2.3.x for size constraints on an embedded device
# This target depends on both $(QTE_QTE_DIR)/$(QTE_UIC_BINARY) **and** $(QTE_QT3_DIR)/.configured. if BR2_QTE_C_QTE_VERSION == BR2_QTE_C_QT3_VERSION,
# then it really depends on $(QTE_QTE_DIR)/.configured, which $(QTE_QTE_DIR)/$(QTE_UIC_BINARY) needs, so it's redundant. If QTE is 3.3.0 or later,
# then BR2_QTE_C_QTE_VERSION != BR2_QTE_C_QT3_VERSION, then we need to unpack the other Qt/E, so this dependency is not redundant.

$(QTE_QTOPIA_DIR)/.configured: $(QTE_QTOPIA_DIR)/.unpacked $(QTE_TMAKE_DIR)/.unpacked $(QTE_QTE_DIR)/$(QTE_UIC_BINARY) $(QTE_QTE_DIR)/$(QTE_QVFB_BINARY) $(QTE_QT3_DIR)/.configured
	(cd $(@D); rm -f config.cache;  export QTDIR=$(QTE_QTE_DIR); export QPEDIR=$(QTE_QTOPIA_DIR); export PATH=$(STAGING_DIR)/bin:$$QTDIR/bin:$$PATH; QT3DIR=$(QTE_QTE_DIR); echo 'yes' | \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		$(QTE_QTOPIA_CONFIGURE) --edition phone -no-qtopiadesktop -dqt $(QTE_QT3_DIR) -arch generic -displaysize 160-240 -languages en_US \
		-platform linux-g++ -qvfb -xplatform $(BR2_QTE_CROSS_PLATFORM) \
	)
	touch $@

# there is no build for tmake, only unpack
$(TMAKE): $(QTE_TMAKE_DIR)/.unpacked

# This must NOT use TARGET_CC -- it is a host-side tool
$(QTE_QVFB_DIR)/.make: $(QTE_QVFB_DIR)/.configured $(TMAKE)
	#$(TARGET_CONFIGURE_OPTS)
	export QTDIR=$(QTE_QVFB_DIR); export PATH=$$QTDIR/bin:$$PATH; \
	$(MAKE) -C $(QTE_QVFB_DIR) src-moc
	touch $@

$(QTE_QTE_DIR)/$(QTE_UIC_BINARY): $(QTE_QVFB_DIR)/.make $(QTE_QTE_DIR)/.unpacked
	export QTDIR=$(QTE_QVFB_DIR); export PATH=$$QTDIR/bin:$$PATH; \
	$(MAKE) -C $(QTE_QVFB_DIR)/tools/designer/uic
	test -d $(@D) || install -dm 0755 $(@D)
	install -m 0755 $(QTE_QVFB_DIR)/bin/$(@F) $@

ifneq ($(BR2_QTE_C_QTE_VERSION),$(BR2_QTE_C_QT3_VERSION))
$(QTE_QT3_DIR)/.make: $(QTE_QT3_DIR)/.unpacked
	( export QTDIR=$(QTE_QT3_DIR); export PATH=$$QTDIR/bin:$$PATH; export LD_LIBRARY_PATH=$$QTDIR/lib:$$LD_LIBRARY_PATH; \
	$(MAKE) -C $(QTE_QT3_DIR) sub-src && \
	$(MAKE) -C $(QTE_QT3_DIR)/tools/linguist/lrelease \
	$(MAKE) -C $(QTE_QT3_DIR)/tools/linguist/lupdate \
	$(MAKE) -C $(QTE_QT3_DIR)/tools/designer/uilib \
	$(MAKE) -C $(QTE_QT3_DIR)/tools/designer/uic
	)
	touch $@
endif

$(QTE_QTE_DIR)/$(QTE_QVFB_BINARY): $(QTE_QVFB_DIR)/.make $(QTE_QTE_DIR)/.unpacked $(TMAKE)
	(cd $(QTE_QVFB_DIR)/tools/qvfb && TMAKEPATH=$(QTE_TMAKE_DIR)/lib/linux-g++ $(TMAKE) -o Makefile qvfb.pro)
	#$(TARGET_CONFIGURE_OPTS)
	export QTDIR=$(QTE_QVFB_DIR); export PATH=$$QTDIR/bin:$$PATH; \
	$(MAKE) -C $(QTE_QVFB_DIR)/tools/qvfb
	test -d $(@D) || install -dm 0755 $(@D)
	install -m 0755 $(QTE_QVFB_DIR)/tools/qvfb/$(@F) $@

$(QTE_QTE_DIR)/src-mt.mk: $(QTE_QTE_DIR)/.configured
	# I don't like the src-mk that gets built, so blow it away. Too many includes to override yet
	echo "SHELL=/bin/sh" > $@
	echo "" >> $@
	echo "src-mt:" >> $@
	echo " cd src; "'$$(MAKE)'" 'QT_THREAD_SUFFIX=-mt' 'QT_LFLAGS_MT="'$$$$(SYSCONF_LFLAGS_THREAD)'" "'$$$$(SYSCONF_LIBS_THREAD)'"' 'QT_CXX_MT="'$$$$(SYSCONF_CXXFLAGS_THREAD)'" -DQT_THREAD_SUPPORT' 'QT_C_MT="'$$$$(SYSCONF_CFLAGS_THREAD)'" -DQT_THREAD_SUPPORT'" >> $@

$(QTE_QTE_LIB): $(QTE_QTE_DIR)/src-mt.mk
	export QTDIR=$(QTE_QTE_DIR); export QPEDIR=$(QTE_QTOPIA_DIR); export PATH=$(STAGING_DIR)/bin:$$QTDIR/bin:$$PATH; \
	$(MAKE) $(TARGET_CONFIGURE_OPTS) $(TARGET_CC) -C $(QTE_QTE_DIR) src-mt
	$(MAKE) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR)/lib -C $(QTE_QTE_DIR) src-mt
	# ... and make sure it actually built... grrr... make deep-deep-deep makefile recursion for this habit
	test -f $@

$(QTE_QTOPIA_FILE): $(QTE_QTOPIA_DIR)/.configured
	export QTDIR=$(QTE_QT3_DIR); export QPEDIR=$(QTE_QTOPIA_DIR); export PATH=$(STAGING_DIR)/bin:$$QTDIR/bin:$$PATH; \
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(QTE_QTOPIA_DIR)

$(QTE_QTOPIA_IFILE): $(QTE_QTOPIA_FILE)
	export QTDIR=$(QTE_QT3_DIR); export QPEDIR=$(QTE_QTOPIA_DIR); export PATH=$(STAGING_DIR)/bin:$$QTDIR/bin:$$PATH; \
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(QTE_QTOPIA_DIR) install PREFIX=$(TARGET_DIR)


qte: $(QTE_QTE_LIB)

ifeq ($(strip $(BR2_PACKAGE_QTE_QTOPIA)),y)
qte: $(QTE_QTOPIA_IFILE)
endif

# kinda no-op right now, these are built anyhow
ifeq ($(strip $(BR2_PACKAGE_QTE_QVFB)),y)
qte: $(QTE_QTE_DIR)/$(QTE_UIC_BINARY) $(QTE_QTE_DIR)/$(QTE_QVFB_BINARY)
endif

qte-clean:
	rm -f $(QTE_QTE_DIR)/$(QTE_UIC_BINARY) $(QTE_QTE_DIR)/$(QTE_QVFB_BINARY) $(QTE_QTE_LIB) $(QTE_QTOPIA_FILE)
	-$(MAKE) -C $(QTE_QTE_DIR) clean
	-$(MAKE) -C $(QTE_QVFB_DIR) clean
	-$(MAKE) -C $(QTE_QTOPIA_DIR) clean

qte-dirclean:
	rm -rf $(QTE_QTE_DIR) $(QTE_QVFB_DIR) $(QTE_QTOPIA_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_QTE)),y)
TARGETS+=qte
endif
