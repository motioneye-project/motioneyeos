################################################################################
#
# ntp
#
################################################################################

NTP_VERSION_MAJOR = 4.2
NTP_VERSION = $(NTP_VERSION_MAJOR).8p10
NTP_SITE = https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-$(NTP_VERSION_MAJOR)
NTP_DEPENDENCIES = host-pkgconf libevent openssl $(if $(BR2_PACKAGE_BUSYBOX),busybox)
NTP_LICENSE = NTP
NTP_LICENSE_FILES = COPYRIGHT
NTP_CONF_ENV = ac_cv_lib_md5_MD5Init=no
NTP_CONF_OPTS = \
	--with-shared \
	--program-transform-name=s,,, \
	--disable-tickadj \
	--disable-debugging \
	--with-yielding-select=yes \
	--disable-local-libevent \
	--with-crypto

# 0002-ntp-syscalls-fallback.patch
# 0003-ntpq-fpic.patch
NTP_AUTORECONF = YES

ifeq ($(BR2_TOOLCHAIN_HAS_SSP),y)
NTP_CONF_OPTS += --with-locfile=linux
else
NTP_CONF_OPTS += --with-locfile=default
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
NTP_CONF_OPTS += --enable-linuxcaps
NTP_DEPENDENCIES += libcap
else
NTP_CONF_OPTS += --disable-linuxcaps
endif

ifeq ($(BR2_PACKAGE_LIBEDIT),y)
NTP_CONF_OPTS += --with-lineeditlibs=edit
NTP_DEPENDENCIES += libedit
else
NTP_CONF_OPTS += --without-lineeditlibs
endif

ifeq ($(BR2_PACKAGE_NTP_NTPSNMPD),y)
NTP_CONF_OPTS += \
	--with-net-snmp-config=$(STAGING_DIR)/usr/bin/net-snmp-config
NTP_DEPENDENCIES += netsnmp
else
NTP_CONF_OPTS += --without-ntpsnmpd
endif

ifeq ($(BR2_PACKAGE_NTP_NTPD_ATOM_PPS),y)
NTP_CONF_OPTS += --enable-ATOM
NTP_DEPENDENCIES += pps-tools
else
NTP_CONF_OPTS += --disable-ATOM
endif

ifeq ($(BR2_PACKAGE_NTP_NTP_SHM_CLK),y)
NTP_CONF_OPTS += --enable-SHM
else
NTP_CONF_OPTS += --disable-SHM
endif

ifeq ($(BR2_PACKAGE_NTP_SNTP),y)
NTP_CONF_OPTS += --with-sntp
else
NTP_CONF_OPTS += --without-sntp
endif

NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTP_KEYGEN) += util/ntp-keygen
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTP_WAIT) += scripts/ntp-wait/ntp-wait
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTPDATE) += ntpdate/ntpdate
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTPDC) += ntpdc/ntpdc
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTPQ) += ntpq/ntpq
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTPSNMPD) += ntpsnmpd/ntpsnmpd
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTPTIME) += util/ntptime
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTPTRACE) += scripts/ntptrace/ntptrace
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_SNTP) += sntp/sntp
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_TICKADJ) += util/tickadj

define NTP_INSTALL_TARGET_CMDS
	$(if $(BR2_PACKAGE_NTP_NTPD), install -m 755 $(@D)/ntpd/ntpd $(TARGET_DIR)/usr/sbin/ntpd)
	test -z "$(NTP_INSTALL_FILES_y)" || install -m 755 $(addprefix $(@D)/,$(NTP_INSTALL_FILES_y)) $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 644 package/ntp/ntpd.etc.conf $(TARGET_DIR)/etc/ntp.conf
endef

ifeq ($(BR2_PACKAGE_NTP_NTPD),y)
define NTP_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/ntp/S49ntp $(TARGET_DIR)/etc/init.d/S49ntp
endef

define NTP_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/ntp/ntpd.service $(TARGET_DIR)/usr/lib/systemd/system/ntpd.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/ntpd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/ntpd.service
endef
endif

$(eval $(autotools-package))
