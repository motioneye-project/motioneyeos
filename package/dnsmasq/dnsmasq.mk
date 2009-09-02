#############################################################
#
# dnsmasq
#
#############################################################

DNSMASQ_VERSION = 2.50
DNSMASQ_SOURCE = dnsmasq-$(DNSMASQ_VERSION).tar.gz
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

ifneq ($(BR2_LARGEFILE),y)
DNSMASQ_COPTS += -DNO_LARGEFILE
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
DNSMASQ_DEPENDENCIES += host-pkgconfig dbus
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

$(DNSMASQ_HOOK_POST_INSTALL):
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -f $(TARGET_DIR)/usr/share/man/man8/dnsmasq.8
endif

$(DNSMASQ_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/sbin/dnsmasq
	rm -f $(TARGET_DIR)/usr/share/man/man8/dnsmasq.8
	rm -f $(DNSMASQ_TARGET_INSTALL_TARGET) $(DNSMASQ_HOOK_POST_INSTALL)
