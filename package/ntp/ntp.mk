################################################################################
#
# ntp
#
################################################################################

NTP_VERSION = 4.2.6p5
NTP_SITE = http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2
NTP_LICENSE = ntp license
NTP_LICENSE_FILES = COPYRIGHT
NTP_CONF_ENV = ac_cv_lib_md5_MD5Init=no

ifneq ($(BR2_INET_IPV6),y)
	NTP_CONF_ENV += isc_cv_have_in6addr_any=no
endif

NTP_CONF_OPT = --with-shared \
		--program-transform-name=s,,, \
		--disable-tickadj

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	NTP_CONF_OPT += --with-crypto
	NTP_DEPENDENCIES += openssl
else
	NTP_CONF_OPT += --without-crypto
endif

ifeq ($(BR2_PACKAGE_NTP_NTPSNMPD),y)
	NTP_CONF_OPT += \
		--with-net-snmp-config=$(STAGING_DIR)/usr/bin/net-snmp-config
	NTP_DEPENDENCIES += netsnmp
else
	NTP_CONF_OPT += --without-ntpsnmpd
endif

define NTP_PATCH_FIXUPS
	$(SED) "s,^#if.*__GLIBC__.*_BSD_SOURCE.*$$,#if 0," $(@D)/ntpd/refclock_pcf.c
	$(SED) '/[[:space:](]rindex[[:space:]]*(/s/[[:space:]]*rindex[[:space:]]*(/ strrchr(/g' $(@D)/ntpd/*.c
endef

NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTP_KEYGEN) += util/ntp-keygen
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTP_WAIT) += scripts/ntp-wait
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTPDATE) += ntpdate/ntpdate
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTPDC) += ntpdc/ntpdc
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTPQ) += ntpq/ntpq
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTPSNMPD) += ntpsnmpd/ntpsnmpd
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_NTPTRACE) += scripts/ntptrace
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_SNTP) += sntp/sntp
NTP_INSTALL_FILES_$(BR2_PACKAGE_NTP_TICKADJ) += util/tickadj

define NTP_INSTALL_TARGET_CMDS
	$(if $(BR2_PACKAGE_NTP_NTPD), install -m 755 $(@D)/ntpd/ntpd $(TARGET_DIR)/usr/sbin/ntpd)
	test -z "$(NTP_INSTALL_FILES_y)" || install -m 755 $(addprefix $(@D)/,$(NTP_INSTALL_FILES_y)) $(TARGET_DIR)/usr/bin/
	$(if $(BR2_PACKAGE_NTP_NTPD), install -m 755 package/ntp/S49ntp $(TARGET_DIR)/etc/init.d/S49ntp)
	@if [ ! -f $(TARGET_DIR)/etc/default/ntpd ]; then \
		install -m 755 -d $(TARGET_DIR)/etc/default ; \
		install -m 644 package/ntp/ntpd.etc.default $(TARGET_DIR)/etc/default/ntpd ; \
	fi
endef

define NTP_UNINSTALL_TARGET_CMDS
	rm $(TARGET_DIR)/usr/sbin/ntpd
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,$(NTP_INSTALL_FILES_y))
	rm $(TARGET_DIR)/etc/init.d/S49ntp
	rm $(TARGET_DIR)/etc/default/ntpd
endef

NTP_POST_PATCH_HOOKS += NTP_PATCH_FIXUPS

$(eval $(autotools-package))
