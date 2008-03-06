################################################################################
#
# cups
#
################################################################################

CUPS_VERSION = 1.3.5
CUPS_SOURCE = cups-$(CUPS_VERSION)-source.tar.bz2
CUPS_SITE = http://ftp.easysw.com/pub/cups/1.3.5
CUPS_AUTORECONF = NO
CUPS_INSTALL_STAGING = YES
CUPS_INSTALL_TARGET = YES
CUPS_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) install DSTROOT=$(STAGING_DIR)
CUPS_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install DSTROOT=$(TARGET_DIR)

ifeq ($(BR2_PACKAGE_DBUS),y)
        CUPS_CONF_OPT_DBUS =--disable-dbus
        CUPS_DEPENDENCIES_DBUS = dbus
else
        CUPS_CONF_OPT_DBUS =--enable-dbus
endif

ifneq ($(BR2_PACKAGE_XSERVER_none),y)
        CUPS_DEPENDENCIES_X = xlib_libX11
endif

CUPS_CONF_OPT = --prefix=/usr --includedir=/usr/include --libdir=/usr/lib --disable-gnutls --disable-gssapi $(CUPS_CONF_OPT_DBUS)
CUPS_MAKE_OPT = cups backend berkeley cgi-bin filter locale monitor notifier pdftops scheduler systemv scripting/php conf data doc fonts ppd templates

CUPS_DEPENDENCIES = $(CUPS_DEPENDENCIES_DBUS) $(CUPS_DEPENDENCIES_X) 

$(eval $(call AUTOTARGETS,package,cups))
