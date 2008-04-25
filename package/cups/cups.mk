################################################################################
#
# cups
#
################################################################################
CUPS_VERSION = 1.3.5
CUPS_NAME = cups-$(CUPS_VERSION)
CUPS_DIR = $(BUILD_DIR)/$(CUPS_NAME)
CUPS_SITE = http://ftp.easysw.com/pub/cups/1.3.5
CUPS_SOURCE:=$(CUPS_NAME)-source.tar.bz2
CUPS_DESTDIR:=$(STAGING_DIR)/usr/lib
CUPS_CAT:=$(BZCAT)

ifeq ($(BR2_PACKAGE_DBUS),y)
        CUPS_CONF_OPT_DBUS =--enable-dbus
        CUPS_DEPENDENCIES_DBUS = dbus
else
        CUPS_CONF_OPT_DBUS =--disable-dbus
endif

ifneq ($(BR2_PACKAGE_XSERVER_none),y)
        CUPS_DEPENDENCIES_X = xlib_libX11
endif

$(DL_DIR)/$(CUPS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(CUPS_SITE)/$(CUPS_SOURCE)

$(CUPS_DIR)/.unpacked: $(DL_DIR)/$(CUPS_SOURCE)
	$(CUPS_CAT) $(DL_DIR)/$(CUPS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(CUPS_DIR) package/cups/ \*.patch
	$(CONFIG_UPDATE) $(CUPS_DIR)
	touch $@

$(CUPS_DIR)/.configured: $(CUPS_DIR)/.unpacked
	(cd $(CUPS_DIR) && \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--prefix=/usr $(CUPS_CONF_OPT_DBUS) --includedir=/usr/include  \
		--libdir=/usr/lib --disable-gnutls --disable-gssapi --host=$(ARCH) \ )
	touch $@

$(CUPS_DIR)/.compiled: $(CUPS_DIR)/.configured
	$(MAKE) -C $(CUPS_DIR) cups backend berkeley cgi-bin filter \
	locale monitor notifier pdftops scheduler systemv scripting/php \
	conf data doc fonts ppd templates
	touch $@

$(CUPS_DIR)/.installed: $(CUPS_DIR)/.compiled
	$(MAKE) -C $(CUPS_DIR) DESTDIR=$(STAGING_DIR) DSTROOT=$(STAGING_DIR) install
	$(MAKE) -C $(CUPS_DIR) DESTDIR=$(TARGET_DIR) DSTROOT=$(TARGET_DIR) install
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/cups-config
	$(SED) "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/cups-config
	$(SED) "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include\',g" $(STAGING_DIR)/usr/bin/cups-config
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/bin/cups-config
	touch $@

cups: uclibc $(CUPS_DEPENDENCIES_DBUS) $(CUPS_DEPENDENCIES_X) $(CUPS_DIR)/.installed

cups-clean:
	-$(MAKE) -C $(CUPS_DIR) clean

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_CUPS)),y)
TARGETS+=cups
endif