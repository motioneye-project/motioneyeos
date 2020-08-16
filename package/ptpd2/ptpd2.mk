################################################################################
#
# ptpd2
#
################################################################################

PTPD2_VERSION = 2.3.1
PTPD2_SITE = $(call github,ptpd,ptpd,ptpd-$(PTPD2_VERSION))
PTPD2_DEPENDENCIES = libpcap
PTPD2_CONF_OPTS = --with-pcap-config=$(STAGING_DIR)/usr/bin/pcap-config
# configure not shipped
PTPD2_AUTORECONF = YES
PTPD2_LICENSE = BSD-2-Clause
PTPD2_LICENSE_FILES = COPYRIGHT

ifeq ($(BR2_STATIC_LIBS),y)
PTPD2_CONF_OPTS += LIBS="`$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`"
endif

ifeq ($(BR2_PACKAGE_NETSNMP),y)
PTPD2_CONF_ENV += ac_cv_path_PATH_NET_SNMP_CONFIG=$(STAGING_DIR)/usr/bin/net-snmp-config
PTPD2_DEPENDENCIES += netsnmp
else
PTPD2_CONF_OPTS += --disable-snmp
endif

define PTPD2_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/ptpd2/S65ptpd2 \
		$(TARGET_DIR)/etc/init.d/S65ptpd2
endef

define PTPD2_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/ptpd2/ptpd2.service \
		$(TARGET_DIR)/usr/lib/systemd/system/ptpd2.service
endef

$(eval $(autotools-package))
