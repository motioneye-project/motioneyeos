#############################################################
#
# dnsmasq
#
#############################################################

DNSMASQ_VERSION = 2.60
DNSMASQ_SITE = http://thekelleys.org.uk/dnsmasq
DNSMASQ_MAKE_ENV = CC="$(TARGET_CC)"
DNSMASQ_MAKE_OPT = COPTS="$(DNSMASQ_COPTS)" PREFIX=/usr CFLAGS="$(TARGET_CFLAGS)"
DNSMASQ_MAKE_OPT += DESTDIR=$(TARGET_DIR) LDFLAGS="$(TARGET_LDFLAGS)"

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
	DNSMASQ_MAKE_OPT += LDFLAGS+="-lintl -lidn"
endif

ifeq ($(BR2_PACKAGE_DNSMASQ_LUA),y)
	DNSMASQ_DEPENDENCIES += lua
	DNSMASQ_MAKE_OPT += LDFLAGS+="-ldl"
endif

ifeq ($(BR2_PACKAGE_DNSMASQ_LUA),y)
define DNSMASQ_ENABLE_LUA
	$(SED) 's/lua5.1/lua/g' $(DNSMASQ_DIR)/Makefile
	$(SED) 's^.*#define HAVE_LUASCRIPT.*^#define HAVE_LUASCRIPT^' \
		$(DNSMASQ_DIR)/src/config.h
endef
endif

ifneq ($(BR2_LARGEFILE),y)
	DNSMASQ_COPTS += -DNO_LARGEFILE
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
	DNSMASQ_DEPENDENCIES += host-pkg-config dbus
endif

define DNSMASQ_FIX_PKGCONFIG
	$(SED) 's^PKG_CONFIG = pkg-config^PKG_CONFIG = $(PKG_CONFIG_HOST_BINARY)^' \
		$(DNSMASQ_DIR)/Makefile
endef

ifeq ($(BR2_PACKAGE_DBUS),y)
define DNSMASQ_ENABLE_DBUS
	$(SED) 's^.*#define HAVE_DBUS.*^#define HAVE_DBUS^' \
		$(DNSMASQ_DIR)/src/config.h
endef
else
define DNSMASQ_ENABLE_DBUS
	$(SED) 's^.*#define HAVE_DBUS.*^/* #define HAVE_DBUS */^' \
		$(DNSMASQ_DIR)/src/config.h
endef
endif

define DNSMASQ_BUILD_CMDS
	$(DNSMASQ_FIX_PKGCONFIG)
	$(DNSMASQ_ENABLE_DBUS)
	$(DNSMASQ_ENABLE_LUA)
	$(DNSMASQ_MAKE_ENV) $(MAKE) -C $(@D) $(DNSMASQ_MAKE_OPT)
endef

define DNSMASQ_INSTALL_TARGET_CMDS
	$(DNSMASQ_MAKE_ENV) $(MAKE) -C $(@D) $(DNSMASQ_MAKE_OPT) install
	mkdir -p $(TARGET_DIR)/var/lib/misc/
endef

define DNSMASQ_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/dnsmasq
	rm -f $(TARGET_DIR)/usr/share/man/man8/dnsmasq.8
endef

$(eval $(call GENTARGETS))
