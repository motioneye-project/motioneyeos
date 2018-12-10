################################################################################
#
# lldpd
#
################################################################################

LLDPD_VERSION = 1.0.1
LLDPD_SITE = http://media.luffy.cx/files/lldpd
LLDPD_DEPENDENCIES = host-pkgconf libevent
LLDPD_LICENSE = ISC
LLDPD_LICENSE_FILES = README.md
# 0002-configure-do-not-check-for-libbsd.patch / 0003-configure-remove-check-on-CXX-compiler.patch
LLDPD_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_CHECK),y)
LLDPD_DEPENDENCIES += check
endif

ifeq ($(BR2_PACKAGE_VALGRIND),y)
LLDPD_DEPENDENCIES += valgrind
endif

# Detection of c99 support in configure fails without WCHAR. To enable
# automatic detection of c99 support by configure, we need to enable
# WCHAR in toolchain. But actually we do not need WCHAR at lldpd
# runtime. So requesting WCHAR in toolchain just for automatic detection
# will be overkill. To solve this, explicitly -specify c99 here.
LLDPD_CONF_ENV = ac_cv_prog_cc_c99=-std=gnu99

LLDPD_CONF_OPTS = \
	--without-embedded-libevent \
	--without-snmp \
	--without-xml \
	--without-json \
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

define LLDPD_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/lldpd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/lldpd.service
endef

$(eval $(autotools-package))
