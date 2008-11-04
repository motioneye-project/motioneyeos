#############################################################
#
# MatchBox WM
#
#############################################################
MATCHBOX_SITE:=http://matchbox-project.org/sources/
MATCHBOX_CAT:=$(BZCAT)

MATCHBOX_LIB_VERSION:=1.9
MATCHBOX_LIB_SOURCE:=libmatchbox-$(MATCHBOX_LIB_VERSION).tar.bz2
MATCHBOX_LIB_DIR:=$(BUILD_DIR)/libmatchbox-$(MATCHBOX_LIB_VERSION)

MATCHBOX_SNOTIFY_VERSION:=0.9
MATCHBOX_SNOTIFY_SOURCE:=startup-notification-$(MATCHBOX_SNOTIFY_VERSION).tar.bz2
MATCHBOX_SNOTIFY_DIR:=$(BUILD_DIR)/startup-notification-$(MATCHBOX_SNOTIFY_VERSION)
#MATCHBOX_SNOTIFY_SITE:=http://www.freedesktop.org/software/startup-notification/releases
MATCHBOX_SNOTIFY_SITE:=http://ftp.gnome.org/pub/GNOME/sources/startup-notification/$(MATCHBOX_SNOTIFY_VERSION)
MATCHBOX_SNOTIFY_CAT:=$(BZCAT)
MATCHBOX_SNOTIFY_BIN:=libstartup-notification-1.so

MATCHBOX_WM_MAJORVER:=1.2
MATCHBOX_WM_MINORVER:=
#MATCHBOX_WM_VERSION:=$(MATCHBOX_WM_MAJORVER).$(MATCHBOX_WM_MINORVER)
MATCHBOX_WM_VERSION:=$(MATCHBOX_WM_MAJORVER)
MATCHBOX_WM_BIN:=matchbox-window-manager
MATCHBOX_WM_SOURCE:=$(MATCHBOX_WM_BIN)-$(MATCHBOX_WM_VERSION).tar.bz2
MATCHBOX_WM_DIR:=$(BUILD_DIR)/$(MATCHBOX_WM_BIN)-$(MATCHBOX_WM_VERSION)

MATCHBOX_CN_MAJORVER:=0.9
MATCHBOX_CN_MINORVER:=1
MATCHBOX_CN_VERSION:=$(MATCHBOX_CN_MAJORVER).$(MATCHBOX_CN_MINORVER)
MATCHBOX_CN_BIN:=matchbox-common
MATCHBOX_CN_SOURCE:=$(MATCHBOX_CN_BIN)-$(MATCHBOX_CN_VERSION).tar.bz2
MATCHBOX_CN_DIR:=$(BUILD_DIR)/$(MATCHBOX_CN_BIN)-$(MATCHBOX_CN_VERSION)

MATCHBOX_PL_MAJORVER:=0.9
MATCHBOX_PL_MINORVER:=3
MATCHBOX_PL_VERSION:=$(MATCHBOX_PL_MAJORVER).$(MATCHBOX_PL_MINORVER)
MATCHBOX_PL_BIN:=matchbox-panel
MATCHBOX_PL_SOURCE:=$(MATCHBOX_PL_BIN)-$(MATCHBOX_PL_VERSION).tar.bz2
MATCHBOX_PL_DIR:=$(BUILD_DIR)/$(MATCHBOX_PL_BIN)-$(MATCHBOX_PL_VERSION)

MATCHBOX_SM_MAJORVER:=0.1
MATCHBOX_SM_MINORVER:=
MATCHBOX_SM_VERSION:=$(MATCHBOX_SM_MAJORVER)$(MATCHBOX_SM_MINORVER)
MATCHBOX_SM_BIN:=mb-applet-startup-monitor
MATCHBOX_SM_SOURCE:=$(MATCHBOX_SM_BIN)-$(MATCHBOX_SM_VERSION).tar.bz2
MATCHBOX_SM_DIR:=$(BUILD_DIR)/$(MATCHBOX_SM_BIN)-$(MATCHBOX_SM_VERSION)

MATCHBOX_DP_MAJORVER:=0.9
MATCHBOX_DP_MINORVER:=1
MATCHBOX_DP_VERSION:=$(MATCHBOX_DP_MAJORVER).$(MATCHBOX_DP_MINORVER)
MATCHBOX_DP_BIN:=matchbox-desktop
MATCHBOX_DP_SOURCE:=$(MATCHBOX_DP_BIN)-$(MATCHBOX_DP_VERSION).tar.bz2
MATCHBOX_DP_DIR:=$(BUILD_DIR)/$(MATCHBOX_DP_BIN)-$(MATCHBOX_DP_VERSION)

MATCHBOX_FK_MAJORVER:=0.1
MATCHBOX_FK_MINORVER:=
#MATCHBOX_FK_VERSION:=$(MATCHBOX_FK_MAJORVER).$(MATCHBOX_FK_MINORVER)
MATCHBOX_FK_VERSION:=$(MATCHBOX_FK_MAJORVER)
MATCHBOX_FK_BIN:=libfakekey
MATCHBOX_FK_SOURCE:=$(MATCHBOX_FK_BIN)-$(MATCHBOX_FK_VERSION).tar.bz2
MATCHBOX_FK_DIR:=$(BUILD_DIR)/$(MATCHBOX_FK_BIN)-$(MATCHBOX_FK_VERSION)

MATCHBOX_KB_MAJORVER:=0.1
MATCHBOX_KB_MINORVER:=
#MATCHBOX_KB_VERSION:=$(MATCHBOX_KB_MAJORVER).$(MATCHBOX_KB_MINORVER)
MATCHBOX_KB_VERSION:=$(MATCHBOX_KB_MAJORVER)
MATCHBOX_KB_BIN:=matchbox-keyboard
MATCHBOX_KB_SOURCE:=$(MATCHBOX_KB_BIN)-$(MATCHBOX_KB_VERSION).tar.bz2
MATCHBOX_KB_DIR:=$(BUILD_DIR)/$(MATCHBOX_KB_BIN)-$(MATCHBOX_KB_VERSION)

#############################################################

$(DL_DIR)/$(MATCHBOX_LIB_SOURCE):
	$(WGET) -P $(DL_DIR) $(MATCHBOX_SITE)/libmatchbox/$(MATCHBOX_LIB_VERSION)/$(MATCHBOX_LIB_SOURCE)

$(DL_DIR)/$(MATCHBOX_SNOTIFY_SOURCE):
	$(WGET) -P $(DL_DIR) $(MATCHBOX_SNOTIFY_SITE)/$(MATCHBOX_SNOTIFY_SOURCE)

$(DL_DIR)/$(MATCHBOX_WM_SOURCE):
	$(WGET) -P $(DL_DIR) $(MATCHBOX_SITE)/$(MATCHBOX_WM_BIN)/$(MATCHBOX_WM_MAJORVER)/$(MATCHBOX_WM_SOURCE)

$(DL_DIR)/$(MATCHBOX_SM_SOURCE):
	$(WGET) -P $(DL_DIR) $(MATCHBOX_SITE)/$(MATCHBOX_SM_BIN)/$(MATCHBOX_SM_MAJORVER)/$(MATCHBOX_SM_SOURCE)

#$(DL_DIR)/$(MATCHBOX_DM_SOURCE):
#	$(WGET) -P $(DL_DIR) $(MATCHBOX_SITE)/$(MATCHBOX_SM_BIN)/$(MATCHBOX_SM_MAJORVER)/$(MATCHBOX_SM_SOURCE)

$(DL_DIR)/$(MATCHBOX_CN_SOURCE):
	$(WGET) -P $(DL_DIR) $(MATCHBOX_SITE)/$(MATCHBOX_CN_BIN)/$(MATCHBOX_CN_MAJORVER)/$(MATCHBOX_CN_SOURCE)

$(DL_DIR)/$(MATCHBOX_PL_SOURCE):
	$(WGET) -P $(DL_DIR) $(MATCHBOX_SITE)/$(MATCHBOX_PL_BIN)/$(MATCHBOX_PL_MAJORVER)/$(MATCHBOX_PL_SOURCE)

$(DL_DIR)/$(MATCHBOX_DP_SOURCE):
	$(WGET) -P $(DL_DIR) $(MATCHBOX_SITE)/$(MATCHBOX_DP_BIN)/$(MATCHBOX_DP_MAJORVER)/$(MATCHBOX_DP_SOURCE)

$(DL_DIR)/$(MATCHBOX_FK_SOURCE):
	$(WGET) -P $(DL_DIR) $(MATCHBOX_SITE)/$(MATCHBOX_FK_BIN)/$(MATCHBOX_FK_MAJORVER)/$(MATCHBOX_FK_SOURCE)

$(DL_DIR)/$(MATCHBOX_KB_SOURCE):
	$(WGET) -P $(DL_DIR) $(MATCHBOX_SITE)/$(MATCHBOX_KB_BIN)/$(MATCHBOX_KB_MAJORVER)/$(MATCHBOX_KB_SOURCE)


matchbox-source: $(DL_DIR)/$(MATCHBOX_LIB_SOURCE) $(DL_DIR)/$(MATCHBOX_WM_SOURCE)

matchbox-panel-source: $(DL_DIR)/$(MATCHBOX_CN_SOURCE) $(DL_DIR)/$(MATCHBOX_PL_SOURCE)

matchbox-desktop-source: $(DL_DIR)/$(MATCHBOX_DP_SOURCE)

matchbox-keyboard-source: $(DL_DIR)/$(MATCHBOX_FK_SOURCE) $(DL_DIR)/$(MATCHBOX_KB_SOURCE)

$(MATCHBOX_LIB_DIR)/.unpacked: $(DL_DIR)/$(MATCHBOX_LIB_SOURCE)
	$(MATCHBOX_CAT) $(DL_DIR)/$(MATCHBOX_LIB_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MATCHBOX_LIB_DIR) package/matchbox/ libmatchbox\*.patch
	touch $(MATCHBOX_LIB_DIR)/.unpacked

$(MATCHBOX_SNOTIFY_DIR)/.unpacked: $(DL_DIR)/$(MATCHBOX_SNOTIFY_SOURCE)
	$(MATCHBOX_SNOTIFY_CAT) $(DL_DIR)/$(MATCHBOX_SNOTIFY_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(MATCHBOX_SNOTIFY_DIR)/.unpacked

$(MATCHBOX_WM_DIR)/.unpacked: $(DL_DIR)/$(MATCHBOX_WM_SOURCE)
	$(MATCHBOX_CAT) $(DL_DIR)/$(MATCHBOX_WM_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(MATCHBOX_WM_DIR)/.unpacked

$(MATCHBOX_SM_DIR)/.unpacked: $(DL_DIR)/$(MATCHBOX_SM_SOURCE)
	$(MATCHBOX_CAT) $(DL_DIR)/$(MATCHBOX_SM_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MATCHBOX_SM_DIR) package/matchbox/ mb-applet-startup-monitor\*.patch
	touch $(MATCHBOX_SM_DIR)/.unpacked

$(MATCHBOX_CN_DIR)/.unpacked: $(DL_DIR)/$(MATCHBOX_CN_SOURCE)
	$(MATCHBOX_CAT) $(DL_DIR)/$(MATCHBOX_CN_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(MATCHBOX_CN_DIR)/.unpacked

$(MATCHBOX_PL_DIR)/.unpacked: $(DL_DIR)/$(MATCHBOX_PL_SOURCE)
	$(MATCHBOX_CAT) $(DL_DIR)/$(MATCHBOX_PL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MATCHBOX_PL_DIR) package/matchbox/ matchbox-panel\*.patch
	touch $(MATCHBOX_PL_DIR)/.unpacked

$(MATCHBOX_DP_DIR)/.unpacked: $(DL_DIR)/$(MATCHBOX_DP_SOURCE)
	$(MATCHBOX_CAT) $(DL_DIR)/$(MATCHBOX_DP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(SED) 's:mbfolder\.png:mbtasks\.png:g' $(MATCHBOX_DP_DIR)/modules/tasks.c
	touch $(MATCHBOX_DP_DIR)/.unpacked

$(MATCHBOX_FK_DIR)/.unpacked: $(DL_DIR)/$(MATCHBOX_FK_SOURCE)
	$(MATCHBOX_CAT) $(DL_DIR)/$(MATCHBOX_FK_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(MATCHBOX_FK_DIR)/.unpacked

$(MATCHBOX_KB_DIR)/.unpacked: $(DL_DIR)/$(MATCHBOX_KB_SOURCE)
	$(MATCHBOX_CAT) $(DL_DIR)/$(MATCHBOX_KB_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(MATCHBOX_KB_DIR)/.unpacked

#############################################################

MATCHBOX_LIB_OPTS:=
MATCHBOX_LIB_DEPS:=

MATCHBOX_WM_OPTS:=
MATCHBOX_WM_DEPS:=xlib_libXdamage
MATCHBOX_WM_DEPS+=xlib_libXcursor

ifeq ($(strip $(BR2_PACKAGE_X11R7_LIBXCOMPOSITE)),y)
ifeq ($(strip $(BR2_PACKAGE_X11R7_LIBXPM)),y)
  MATCHBOX_WM_OPTS+=--enable-composite
  MATCHBOX_WM_DEPS+=xlib_libXcomposite
  MATCHBOX_WM_DEPS+=xlib_libXpm
  MATCHBOX_LIB_DEPS+=xlib_libXpm
endif
endif

MATCHBOX_SNOTIFY_OPTS:=
MATCHBOX_SNOTIFY_DEPS:=
MATCHBOX_PANEL_DEPS:=

ifeq ($(strip $(BR2_PACKAGE_MATCHBOX_SNOTIFY)),y)
  MATCHBOX_SNOTIFY_OPTS+=--enable-startup-notification
  MATCHBOX_SNOTIFY_DEPS+=xlib_libSM
  MATCHBOX_SNOTIFY_DEPS+=$(TARGET_DIR)/usr/lib/$(MATCHBOX_SNOTIFY_BIN)
  MATCHBOX_PANEL_DEPS+=$(TARGET_DIR)/usr/bin/$(MATCHBOX_SM_BIN)
else
  MATCHBOX_SNOTIFY_OPTS+=--disable-startup-notification
endif

ifeq ($(strip $(BR2_PACKAGE_JPEG)),y)
  MATCHBOX_LIB_OPTS+=--enable-jpeg
  MATCHBOX_LIB_DEPS+=jpeg
else
  MATCHBOX_LIB_OPTS+=--disable-jpeg
endif

ifeq ($(strip $(BR2_PACKAGE_LIBPNG)),y)
  MATCHBOX_LIB_OPTS+=--enable-png
  MATCHBOX_LIB_DEPS+=libpng
else
  MATCHBOX_LIB_OPTS+=--disable-png
endif

ifeq ($(strip $(BR2_PACKAGE_PANGO)),y)
  MATCHBOX_LIB_OPTS+=--enable-pango
  MATCHBOX_LIB_DEPS+=pango
else
  MATCHBOX_LIB_OPTS+=--disable-pango
endif

ifeq ($(strip $(BR2_PACKAGE_X11R7_LIBXFT2)),y)
  MATCHBOX_LIB_OPTS+=--enable-xft
  MATCHBOX_LIB_DEPS+=xlib_libXft2
  #MATCHBOX_WM_OPTS+=--enable-standalone-xft
  MATCHBOX_WM_DEPS+=xlib_libXft2
else
  MATCHBOX_LIB_OPTS+=--disable-xft
  #MATCHBOX_WM_OPTS+=--disable-standalone-xft
endif


$(MATCHBOX_LIB_DIR)/.configured: $(MATCHBOX_LIB_DIR)/.unpacked xlib_libXext-install-staging
	(cd $(MATCHBOX_LIB_DIR); rm -f config.cache; \
	$(TARGET_CONFIGURE_OPTS) \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--disable-static \
	--prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--datadir=/usr/share/matchbox \
	--libdir=$(STAGING_DIR)/usr/lib \
	--includedir=$(STAGING_DIR)/usr/include \
	--enable-expat \
	--disable-doxygen-docs \
	--with-expat-includes=$(STAGING_DIR)/usr/include \
	--with-expat-lib=$(STAGING_DIR)/usr/lib \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	$(MATCHBOX_LIB_OPTS) \
	)
	touch $(MATCHBOX_LIB_DIR)/.configured

$(MATCHBOX_SNOTIFY_DIR)/.configured: $(MATCHBOX_SNOTIFY_DIR)/.unpacked
	(cd $(MATCHBOX_SNOTIFY_DIR); rm -f config.cache; \
	$(TARGET_CONFIGURE_OPTS) \
	lf_cv_sane_realloc=no \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--disable-static \
	--prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--datadir=/usr/share \
	--libdir=$(STAGING_DIR)/usr/lib \
	--includedir=/usr/include \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	)
	touch $(MATCHBOX_SNOTIFY_DIR)/.configured

$(MATCHBOX_WM_DIR)/.configured: $(MATCHBOX_WM_DIR)/.unpacked
	(cd $(MATCHBOX_WM_DIR); rm -f config.cache; \
	$(TARGET_CONFIGURE_OPTS) \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--disable-static \
	--prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--datadir=/usr/share/matchbox \
	--libdir=$(STAGING_DIR)/usr/lib \
	--includedir=$(STAGING_DIR)/usr/include \
	--enable-expat \
	--with-expat-includes=$(STAGING_DIR)/usr/include \
	--with-expat-lib=$(STAGING_DIR)/usr/lib \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	$(MATCHBOX_WM_OPTS) \
	$(MATCHBOX_SNOTIFY_OPTS) \
	)
	touch $(MATCHBOX_WM_DIR)/.configured

$(MATCHBOX_SM_DIR)/.configured: $(MATCHBOX_SM_DIR)/.unpacked
	(cd $(MATCHBOX_SM_DIR); rm -f config.cache; \
	$(TARGET_CONFIGURE_OPTS) \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--disable-static \
	--prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--datadir=/usr/share/matchbox \
	--libdir=$(STAGING_DIR)/usr/lib \
	--includedir=$(STAGING_DIR)/usr/include \
	--enable-expat \
	--with-expat-includes=$(STAGING_DIR)/usr/include \
	--with-expat-lib=$(STAGING_DIR)/usr/lib \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	$(MATCHBOX_SNOTIFY_OPTS) \
	)
	touch $(MATCHBOX_SM_DIR)/.configured

$(MATCHBOX_CN_DIR)/.configured: $(MATCHBOX_CN_DIR)/.unpacked
	(cd $(MATCHBOX_CN_DIR); rm -f config.cache; \
	$(TARGET_CONFIGURE_OPTS) \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--disable-static \
	--prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--datadir=/usr/share/matchbox \
	--libdir=$(STAGING_DIR)/usr/lib \
	--includedir=$(STAGING_DIR)/usr/include \
	--enable-expat \
	--with-expat-includes=$(STAGING_DIR)/usr/include \
	--with-expat-lib=$(STAGING_DIR)/usr/lib \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	)
	touch $(MATCHBOX_CN_DIR)/.configured

$(MATCHBOX_PL_DIR)/.configured: $(MATCHBOX_PL_DIR)/.unpacked
	(cd $(MATCHBOX_PL_DIR); rm -f config.cache; \
	$(TARGET_CONFIGURE_OPTS) \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--disable-static \
	--prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--datadir=/usr/share/matchbox \
	--libdir=/usr/lib \
	--includedir=/usr/include \
	--enable-expat \
	--with-expat-includes=$(STAGING_DIR)/usr/include \
	--with-expat-lib=$(STAGING_DIR)/usr/lib \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	$(MATCHBOX_SNOTIFY_OPTS) \
	)
	touch $(MATCHBOX_PL_DIR)/.configured

$(MATCHBOX_DP_DIR)/.configured: $(MATCHBOX_DP_DIR)/.unpacked
	(cd $(MATCHBOX_DP_DIR); rm -f config.cache; \
	$(TARGET_CONFIGURE_OPTS) \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--disable-static \
	--prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--datadir=/usr/share/matchbox \
	--libdir=$(STAGING_DIR)/usr/lib \
	--includedir=$(STAGING_DIR)/usr/include \
	--enable-expat \
	--with-expat-includes=$(STAGING_DIR)/usr/include \
	--with-expat-lib=$(STAGING_DIR)/usr/lib \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	$(MATCHBOX_SNOTIFY_OPTS) \
	)
	touch $(MATCHBOX_DP_DIR)/.configured

$(MATCHBOX_FK_DIR)/.configured: $(MATCHBOX_FK_DIR)/.unpacked
	(cd $(MATCHBOX_FK_DIR); rm -f config.cache; \
	$(TARGET_CONFIGURE_OPTS) \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--disable-static \
	--prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--datadir=/usr/share/matchbox \
	--libdir=$(STAGING_DIR)/usr/lib \
	--includedir=$(STAGING_DIR)/usr/include \
	--enable-expat \
	--with-expat-includes=$(STAGING_DIR)/usr/include \
	--with-expat-lib=$(STAGING_DIR)/usr/lib \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	)
	$(SED) 's:^SUBDIRS = fakekey src tests.*:SUBDIRS = fakekey src:g' $(MATCHBOX_FK_DIR)/Makefile
	touch $(MATCHBOX_FK_DIR)/.configured

$(MATCHBOX_KB_DIR)/.configured: $(MATCHBOX_KB_DIR)/.unpacked
	(cd $(MATCHBOX_KB_DIR); rm -f config.cache; \
	$(TARGET_CONFIGURE_OPTS) \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--disable-static \
	--prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--datadir=/usr/share/matchbox \
	--libdir=$(STAGING_DIR)/usr/lib \
	--includedir=$(STAGING_DIR)/usr/include \
	--enable-expat \
	--with-expat-includes=$(STAGING_DIR)/usr/include \
	--with-expat-lib=$(STAGING_DIR)/usr/lib \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	)
	touch $(MATCHBOX_KB_DIR)/.configured

$(MATCHBOX_LIB_DIR)/.compiled: $(MATCHBOX_LIB_DIR)/.configured
	$(MAKE) -C $(MATCHBOX_LIB_DIR)
	touch $(MATCHBOX_LIB_DIR)/.compiled

$(MATCHBOX_SNOTIFY_DIR)/.compiled: $(MATCHBOX_SNOTIFY_DIR)/.configured
	$(MAKE) -C $(MATCHBOX_SNOTIFY_DIR)
	touch $(MATCHBOX_SNOTIFY_DIR)/.compiled

$(MATCHBOX_WM_DIR)/.compiled: $(MATCHBOX_WM_DIR)/.configured
	$(MAKE) -C $(MATCHBOX_WM_DIR)
	touch $(MATCHBOX_WM_DIR)/.compiled

$(MATCHBOX_SM_DIR)/.compiled: $(MATCHBOX_SM_DIR)/.configured
	$(MAKE) -C $(MATCHBOX_SM_DIR)
	touch $(MATCHBOX_SM_DIR)/.compiled

$(MATCHBOX_CN_DIR)/.compiled: $(MATCHBOX_CN_DIR)/.configured
	$(MAKE) -C $(MATCHBOX_CN_DIR)
	touch $(MATCHBOX_CN_DIR)/.compiled

$(MATCHBOX_PL_DIR)/.compiled: $(MATCHBOX_PL_DIR)/.configured
	$(MAKE) -C $(MATCHBOX_PL_DIR)
	touch $(MATCHBOX_PL_DIR)/.compiled

$(MATCHBOX_DP_DIR)/.compiled: $(MATCHBOX_DP_DIR)/.configured
	$(MAKE) -C $(MATCHBOX_DP_DIR)
	touch $(MATCHBOX_DP_DIR)/.compiled

$(MATCHBOX_FK_DIR)/.compiled: $(MATCHBOX_FK_DIR)/.configured
	$(MAKE) -C $(MATCHBOX_FK_DIR)
	touch $(MATCHBOX_FK_DIR)/.compiled

$(MATCHBOX_KB_DIR)/.compiled: $(MATCHBOX_KB_DIR)/.configured
	$(MAKE) -C $(MATCHBOX_KB_DIR)
	touch $(MATCHBOX_KB_DIR)/.compiled

$(STAGING_DIR)/usr/lib/libmb.so: $(MATCHBOX_LIB_DIR)/.compiled
	$(MAKE) -C $(MATCHBOX_LIB_DIR) DESTDIR=$(STAGING_DIR) \
	prefix=/usr \
	localstatedir=/var \
	datadir=/usr/share/matchbox \
	libdir=/usr/lib \
	includedir=/usr/include \
	install
	$(SED) "s:\(['= ]\)/usr:\1$(STAGING_DIR)/usr:g" $(STAGING_DIR)/usr/lib/libmb.la

$(STAGING_DIR)/usr/lib/$(MATCHBOX_SNOTIFY_BIN): $(MATCHBOX_SNOTIFY_DIR)/.compiled
	$(MAKE) -C $(MATCHBOX_SNOTIFY_DIR) DESTDIR=$(STAGING_DIR) \
	prefix=/usr \
	localstatedir=/var \
	datadir=/usr/share \
	libdir=/usr/lib \
	includedir=/usr/include \
	install

$(STAGING_DIR)/usr/bin/$(MATCHBOX_WM_BIN): $(MATCHBOX_WM_DIR)/.compiled
	$(MAKE) -C $(MATCHBOX_WM_DIR) DESTDIR=$(STAGING_DIR) \
	prefix=/usr \
	localstatedir=/var \
	datadir=/usr/share/matchbox \
	libdir=/usr/lib \
	includedir=/usr/include \
	install

$(STAGING_DIR)/usr/bin/$(MATCHBOX_SM_BIN): $(MATCHBOX_SM_DIR)/.compiled
	$(MAKE) -C $(MATCHBOX_SM_DIR) DESTDIR=$(STAGING_DIR) \
	prefix=/usr \
	localstatedir=/var \
	datadir=/usr/share/matchbox \
	libdir=/usr/lib \
	includedir=/usr/include \
	install

$(STAGING_DIR)/usr/bin/matchbox-session: $(MATCHBOX_CN_DIR)/.compiled
	$(MAKE) -C $(MATCHBOX_CN_DIR) DESTDIR=$(STAGING_DIR) \
	prefix=/usr \
	localstatedir=/var \
	datadir=/usr/share/matchbox \
	libdir=/usr/lib \
	includedir=/usr/include \
	install

$(STAGING_DIR)/usr/bin/$(MATCHBOX_PL_BIN): $(MATCHBOX_PL_DIR)/.compiled
	$(MAKE) -C $(MATCHBOX_PL_DIR) DESTDIR=$(STAGING_DIR) \
	prefix=/usr \
	localstatedir=/var \
	datadir=/usr/share/matchbox \
	libdir=/usr/lib \
	includedir=/usr/include \
	install

$(STAGING_DIR)/usr/bin/$(MATCHBOX_DP_BIN): $(MATCHBOX_DP_DIR)/.compiled
	$(MAKE) -C $(MATCHBOX_DP_DIR) DESTDIR=$(STAGING_DIR) \
	prefix=/usr \
	localstatedir=/var \
	datadir=/usr/share/matchbox \
	libdir=/usr/lib \
	includedir=/usr/include \
	install

$(STAGING_DIR)/usr/lib/$(MATCHBOX_FK_BIN).so: $(MATCHBOX_FK_DIR)/.compiled
	$(MAKE) -C $(MATCHBOX_FK_DIR) DESTDIR=$(STAGING_DIR) \
	prefix=/usr \
	localstatedir=/var \
	datadir=/usr/share/matchbox \
	libdir=/usr/lib \
	includedir=/usr/include \
	install

$(STAGING_DIR)/usr/bin/$(MATCHBOX_KB_BIN): $(MATCHBOX_KB_DIR)/.compiled
	$(MAKE) -C $(MATCHBOX_KB_DIR) DESTDIR=$(STAGING_DIR) \
	prefix=/usr \
	localstatedir=/var \
	datadir=/usr/share/matchbox \
	libdir=/usr/lib \
	includedir=/usr/include \
	install

$(TARGET_DIR)/usr/lib/libmb.so: $(STAGING_DIR)/usr/lib/libmb.so
	cp -dpf $(STAGING_DIR)/usr/lib/libmb.so* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libmb.so

$(TARGET_DIR)/usr/lib/$(MATCHBOX_SNOTIFY_BIN): $(STAGING_DIR)/usr/lib/$(MATCHBOX_SNOTIFY_BIN)
	cp -dpf $(STAGING_DIR)/usr/lib/$(MATCHBOX_SNOTIFY_BIN)* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/$(MATCHBOX_SNOTIFY_BIN)

$(TARGET_DIR)/usr/bin/$(MATCHBOX_WM_BIN): $(STAGING_DIR)/usr/bin/$(MATCHBOX_WM_BIN)
	cp -dpf $(STAGING_DIR)/usr/bin/$(MATCHBOX_WM_BIN) $(TARGET_DIR)/usr/bin/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/$(MATCHBOX_WM_BIN)
	cp -dpf $(STAGING_DIR)/usr/bin/matchbox-remote $(TARGET_DIR)/usr/bin/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/matchbox-remote
	cp -af $(STAGING_DIR)/etc/matchbox/ $(TARGET_DIR)/etc/
	cp -af $(STAGING_DIR)/usr/share/matchbox $(TARGET_DIR)/usr/share/

$(TARGET_DIR)/usr/bin/$(MATCHBOX_SM_BIN): $(STAGING_DIR)/usr/bin/$(MATCHBOX_SM_BIN)
	cp -dpf $(STAGING_DIR)/usr/bin/$(MATCHBOX_SM_BIN) $(TARGET_DIR)/usr/bin/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/$(MATCHBOX_SM_BIN)
	mkdir -p $(TARGET_DIR)/usr/share/matchbox/pixmaps/
	cp -af $(STAGING_DIR)/usr/share/matchbox/pixmaps/hourglass-*.png $(TARGET_DIR)/usr/share/matchbox/pixmaps/

$(TARGET_DIR)/usr/bin/matchbox-session: $(STAGING_DIR)/usr/bin/matchbox-session
	cp -dpf $(STAGING_DIR)/usr/bin/matchbox-session $(TARGET_DIR)/usr/bin/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/matchbox-session
	cp -af $(STAGING_DIR)/etc/matchbox/ $(TARGET_DIR)/etc/
	cp -af $(STAGING_DIR)/usr/share/matchbox $(TARGET_DIR)/usr/share/

$(TARGET_DIR)/usr/bin/$(MATCHBOX_PL_BIN): $(STAGING_DIR)/usr/bin/$(MATCHBOX_PL_BIN)
	cp -dpf $(STAGING_DIR)/usr/bin/$(MATCHBOX_PL_BIN) $(TARGET_DIR)/usr/bin/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/$(MATCHBOX_PL_BIN)
	cp -dpf $(STAGING_DIR)/usr/bin/mb-applet-* $(TARGET_DIR)/usr/bin/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/mb-applet-*
	cp -af $(STAGING_DIR)/usr/share/matchbox/* $(TARGET_DIR)/usr/share/matchbox/

$(TARGET_DIR)/usr/bin/$(MATCHBOX_DP_BIN): $(STAGING_DIR)/usr/bin/$(MATCHBOX_DP_BIN)
	cp -dpf $(STAGING_DIR)/usr/bin/$(MATCHBOX_DP_BIN) $(TARGET_DIR)/usr/bin/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/$(MATCHBOX_DP_BIN)
	cp -dpf $(STAGING_DIR)/usr/lib/dotdesktop.so $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/dotdesktop.so
	cp -dpf $(STAGING_DIR)/usr/lib/simplefilebrowser.so $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/simplefilebrowser.so
	cp -dpf $(STAGING_DIR)/usr/lib/tasks.so $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/tasks.so
	cp -af $(STAGING_DIR)/usr/share/matchbox/* $(TARGET_DIR)/usr/share/matchbox/
	cp -f ./package/matchbox/mbdesktop_modules $(TARGET_DIR)/etc/matchbox/

$(TARGET_DIR)/usr/lib/$(MATCHBOX_FK_BIN).so: $(STAGING_DIR)/usr/lib/$(MATCHBOX_FK_BIN).so
	cp -dpf $(STAGING_DIR)/usr/lib/$(MATCHBOX_FK_BIN).so* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/$(MATCHBOX_FK_BIN).so

$(TARGET_DIR)/usr/bin/$(MATCHBOX_KB_BIN): $(STAGING_DIR)/usr/bin/$(MATCHBOX_KB_BIN)
	cp -dpf $(STAGING_DIR)/usr/bin/$(MATCHBOX_KB_BIN) $(TARGET_DIR)/usr/bin/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/$(MATCHBOX_KB_BIN)
	mkdir -p $(TARGET_DIR)/usr/share/matchbox/pixmaps/
	cp -dpf $(STAGING_DIR)/usr/share/matchbox/pixmaps/matchbox-keyboard.png $(TARGET_DIR)/usr/share/matchbox/pixmaps/
	cp -af $(STAGING_DIR)/usr/share/matchbox/matchbox-keyboard $(TARGET_DIR)/usr/share/matchbox/
	cp -dpf ./package/matchbox/mb-applet-kbd-wrapper.sh $(TARGET_DIR)/usr/bin/

matchbox: uclibc pkgconfig expat $(MATCHBOX_WM_DEPS) $(MATCHBOX_SNOTIFY_DEPS) $(MATCHBOX_LIB_DEPS) $(TARGET_DIR)/usr/lib/libmb.so $(TARGET_DIR)/usr/bin/$(MATCHBOX_WM_BIN)

matchbox-panel: uclibc matchbox $(TARGET_DIR)/usr/bin/$(MATCHBOX_PL_BIN) $(TARGET_DIR)/usr/bin/matchbox-session $(MATCHBOX_PANEL_DEPS)

matchbox-desktop: uclibc matchbox $(TARGET_DIR)/usr/bin/$(MATCHBOX_DP_BIN)

matchbox-keyboard: uclibc matchbox xlib_libXtst $(TARGET_DIR)/usr/lib/$(MATCHBOX_FK_BIN).so $(TARGET_DIR)/usr/bin/$(MATCHBOX_KB_BIN)

matchbox-clean:
	rm -f $(TARGET_DIR)/usr/lib/libmb.*
	rm -f $(TARGET_DIR)/usr/bin/$(MATCHBOX_WM_BIN)
	$(MAKE) DESTDIR=$(STAGING_DIR) CC=$(TARGET_CC) -C $(MATCHBOX_WM_DIR) uninstall
	-$(MAKE) -C $(MATCHBOX_WM_DIR) clean
	$(MAKE) DESTDIR=$(STAGING_DIR) CC=$(TARGET_CC) -C $(MATCHBOX_LIB_DIR) uninstall
	-$(MAKE) -C $(MATCHBOX_LIB_DIR) clean

matchbox-panel-clean:
	rm -f $(TARGET_DIR)/usr/bin/$(MATCHBOX_PL_BIN)
	rm -f $(TARGET_DIR)/usr/bin/matchbox-session
	$(MAKE) DESTDIR=$(STAGING_DIR) CC=$(TARGET_CC) -C $(MATCHBOX_PL_DIR) uninstall
	-$(MAKE) -C $(MATCHBOX_PL_DIR) clean
	$(MAKE) DESTDIR=$(STAGING_DIR) CC=$(TARGET_CC) -C $(MATCHBOX_CN_DIR) uninstall
	-$(MAKE) -C $(MATCHBOX_CN_DIR) clean

matchbox-desktop-clean:
	rm -f $(TARGET_DIR)/usr/bin/$(MATCHBOX_DP_BIN)
	$(MAKE) DESTDIR=$(STAGING_DIR) CC=$(TARGET_CC) -C $(MATCHBOX_DP_DIR) uninstall
	-$(MAKE) -C $(MATCHBOX_DP_DIR) clean

matchbox-keyboard-clean:
	rm -f $(TARGET_DIR)/usr/bin/$(MATCHBOX_KB_BIN)
	rm -f $(TARGET_DIR)/usr/lib/$(MATCHBOX_FK_BIN).*
	$(MAKE) DESTDIR=$(STAGING_DIR) CC=$(TARGET_CC) -C $(MATCHBOX_KB_DIR) uninstall
	-$(MAKE) -C $(MATCHBOX_KB_DIR) clean
	$(MAKE) DESTDIR=$(STAGING_DIR) CC=$(TARGET_CC) -C $(MATCHBOX_FK_DIR) uninstall
	-$(MAKE) -C $(MATCHBOX_FK_DIR) clean

matchbox-dirclean:
	rm -rf $(MATCHBOX_WM_DIR)
	rm -rf $(MATCHBOX_LIB_DIR)
	rm -rf $(MATCHBOX_SNOTIFY_DIR)

matchbox-panel-dirclean:
	rm -rf $(MATCHBOX_PL_DIR)
	rm -rf $(MATCHBOX_CN_DIR)

matchbox-desktop-dirclean:
	rm -rf $(MATCHBOX_DP_DIR)

matchbox-keyboard-dirclean:
	rm -rf $(MATCHBOX_KB_DIR)
	rm -rf $(MATCHBOX_FK_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MATCHBOX)),y)
TARGETS+=matchbox
endif

ifeq ($(strip $(BR2_PACKAGE_MATCHBOX_PANEL)),y)
TARGETS+=matchbox-panel
endif

ifeq ($(strip $(BR2_PACKAGE_MATCHBOX_DESKTOP)),y)
TARGETS+=matchbox-desktop
endif

ifeq ($(strip $(BR2_PACKAGE_MATCHBOX_KEYBOARD)),y)
TARGETS+=matchbox-keyboard
endif
