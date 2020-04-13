################################################################################
#
# lldpd
#
################################################################################

LLDPD_VERSION = 1.0.5
LLDPD_SITE = https://media.luffy.cx/files/lldpd
LLDPD_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_CHECK),check) \
	host-pkgconf \
	$(if $(BR2_PACKAGE_LIBCAP),libcap) \
	libevent \
	$(if $(BR2_PACKAGE_VALGRIND),valgrind)
LLDPD_LICENSE = ISC
LLDPD_LICENSE_FILES = LICENSE

# Detection of c99 support in configure fails without WCHAR. To enable
# automatic detection of c99 support by configure, we need to enable
# WCHAR in toolchain. But actually we do not need WCHAR at lldpd
# runtime. So requesting WCHAR in toolchain just for automatic detection
# will be overkill. To solve this, explicitly -specify c99 here.
LLDPD_CONF_ENV = ac_cv_prog_cc_c99=-std=gnu99

LLDPD_CONF_OPTS = \
	--without-embedded-libevent \
	--without-seccomp \
	--without-libbsd \
	--disable-hardening \
	--disable-privsep \
	$(if $(BR2_PACKAGE_LLDPD_CDP),--enable-cdp,--disable-cdp) \
	$(if $(BR2_PACKAGE_LLDPD_FDP),--enable-fdp,--disable-fdp) \
	$(if $(BR2_PACKAGE_LLDPD_EDP),--enable-edp,--disable-edp) \
	$(if $(BR2_PACKAGE_LLDPD_SONMP),--enable-sonmp,--disable-sonmp) \
	$(if $(BR2_PACKAGE_LLDPD_LLDPMED),--enable-lldpmed,--disable-lldpmed) \
	$(if $(BR2_PACKAGE_LLDPD_DOT1),--enable-dot1,--disable-dot1) \
	$(if $(BR2_PACKAGE_LLDPD_DOT3),--enable-dot3,--disable-dot3) \
	$(if $(BR2_PACKAGE_LLDPD_CUSTOM_TLV),--enable-custom,--disable-custom)

ifeq ($(BR2_PACKAGE_LIBXML2),y)
LLDPD_CONF_OPTS += --with-xml
LLDPD_DEPENDENCIES += libxml2
else
LLDPD_CONF_OPTS += --without-xml
endif

ifeq ($(BR2_PACKAGE_NETSNMP),y)
LLDPD_CONF_OPTS += --with-snmp
LLDPD_DEPENDENCIES += netsnmp
LLDPD_CONF_ENV += \
	ac_cv_path_NETSNMP_CONFIG=$(STAGING_DIR)/usr/bin/net-snmp-config
else
LLDPD_CONF_OPTS += --without-snmp
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
LLDPD_CONF_OPTS += --with-readline
LLDPD_DEPENDENCIES += readline
else
LLDPD_CONF_OPTS += --without-readline
endif

define LLDPD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/lldpd/S60lldpd \
		$(TARGET_DIR)/etc/init.d/S60lldpd
endef

$(eval $(autotools-package))
