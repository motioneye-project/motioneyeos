################################################################################
#
# cups
#
################################################################################

CUPS_VERSION = 1.3.9
CUPS_SOURCE = cups-$(CUPS_VERSION)-source.tar.bz2
CUPS_SITE = http://ftp.easysw.com/pub/cups/$(CUPS_VERSION)
CUPS_INSTALL_STAGING = YES
CUPS_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) DSTROOT=$(STAGING_DIR) install
CUPS_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) DSTROOT=$(TARGET_DIR) install
CUPS_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) $(CUPS_CFLAGS)"
CUPS_CONF_OPT = --without-perl \
		--without-java \
		--disable-gnutls \
		--disable-gssapi

ifeq ($(BR2_PACKAGE_DBUS),y)
	CUPS_CONF_OPT += --enable-dbus
	CUPS_DEPENDENCIES += dbus
else
	CUPS_CONF_OPT += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
	CUPS_DEPENDENCIES += xlib_libX11
endif

ifeq ($(BR2_PACKAGE_PHP),y)
	CUPS_CONF_ENV += ac_cv_path_PHPCONFIG=$(STAGING_DIR)/usr/bin/php-config
	CUPS_CONF_OPT += --with-php
	CUPS_DEPENDENCIES += php
else
	CUPS_CONF_OPT += --without-php
endif

ifeq ($(BR2_PACKAGE_PYTHON),y)
	CUPS_CFLAGS += 		-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)
	CUPS_CONF_ENV +=	ac_cv_path_python=$(STAGING_DIR)/usr/bin/python
	CUPS_CONF_OPT +=	--with-python
	CUPS_DEPENDENCIES +=	python
else
	CUPS_CONF_OPT +=	--without-python
endif

ifeq ($(BR2_PACKAGE_CUPS_PDFTOPS),y)
	CUPS_CONF_OPT += --enable-pdftops
else
	CUPS_CONF_OPT += --disable-pdftops
endif

# standard autoreconf fails with autoheader failures
define CUPS_FIXUP_AUTOCONF
	cd $(@D) && $(AUTOCONF)
endef
CUPS_DEPENDENCIES += host-autoconf

CUPS_PRE_CONFIGURE_HOOKS += CUPS_FIXUP_AUTOCONF

# Fixup prefix= and exec_prefix= in cups-config, and remove the
# -Wl,-rpath option.
define CUPS_FIXUP_CUPS_CONFIG
	$(SED) 's%prefix=/usr%prefix=$(STAGING_DIR)/usr%' \
		$(STAGING_DIR)/usr/bin/cups-config
	$(SED) 's%exec_prefix=/usr%exec_prefix=$(STAGING_DIR)/usr%' \
		$(STAGING_DIR)/usr/bin/cups-config
	$(SED) "s%includedir=.*%includedir=$(STAGING_DIR)/usr/include%" \
		 $(STAGING_DIR)/usr/bin/cups-config
	$(SED) 's%-Wl,-rpath,\$${libdir}%%' \
		$(STAGING_DIR)/usr/bin/cups-config
endef

CUPS_POST_INSTALL_STAGING_HOOKS += CUPS_FIXUP_CUPS_CONFIG

$(eval $(call AUTOTARGETS))
