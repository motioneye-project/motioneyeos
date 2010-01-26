#############################################################
#
# dnsmasq
#
#############################################################

DNSMASQ_VERSION = 2.52
DNSMASQ_SITE = http://thekelleys.org.uk/dnsmasq
DNSMASQ_AUTORECONF = NO
DNSMASQ_MAKE_ENV = CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"
DNSMASQ_MAKE_OPT = COPTS="$(DNSMASQ_COPTS)" PREFIX=/usr
DNSMASQ_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) PREFIX=/usr install

ifneq ($(BR2_INET_IPV6),y)
DNSMASQ_COPTS += -DNO_IPV6
endif

ifneq ($(BR2_PACKAGE_DNSMASQ_DHCP),y)
DNSMASQ_COPTS += -DNO_DHCP
endif

ifneq ($(BR2_PACKAGE_DNSMASQ_TFTP),y)
DNSMASQ_COPTS += -DNO_TFTP
endif

ifeq ($(BR2_PACKAGE_DNSMASQ_IDN),y)
DNSMASQ_MAKE_OPT += all-i18n
DNSMASQ_DEPENDENCIES += libidn libintl
DNSMASQ_MAKE_ENV += LDFLAGS+="-lintl"
endif

ifneq ($(BR2_LARGEFILE),y)
DNSMASQ_COPTS += -DNO_LARGEFILE
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
DNSMASQ_DEPENDENCIES += host-pkg-config dbus
endif

$(eval $(call AUTOTARGETS,package,dnsmasq))

$(DNSMASQ_TARGET_CONFIGURE):
ifeq ($(BR2_PACKAGE_DBUS),y)
	$(SED) 's^.*#define HAVE_DBUS.*^#define HAVE_DBUS^' \
		$(DNSMASQ_DIR)/src/config.h
	$(SED) 's^PKG_CONFIG = pkg-config^PKG_CONFIG = $(PKG_CONFIG_HOST_BINARY)^' \
		$(DNSMASQ_DIR)/Makefile
	$(SED) 's^--cflags dbus-1^--cflags dbus-1 \| sed s\\\#-I/\\\#-I$(STAGING_DIR)/\\\#g^' \
		$(DNSMASQ_DIR)/Makefile
else
	$(SED) 's^.*#define HAVE_DBUS.*^/* #define HAVE_DBUS */^' \
		$(DNSMASQ_DIR)/src/config.h
endif
	touch $@

$(DNSMASQ_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/sbin/dnsmasq
	rm -f $(TARGET_DIR)/usr/share/man/man8/dnsmasq.8
	rm -f $(DNSMASQ_TARGET_INSTALL_TARGET) $(DNSMASQ_HOOK_POST_INSTALL)
