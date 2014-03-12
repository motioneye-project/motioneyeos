################################################################################
#
# ptpd2
#
################################################################################

PTPD2_VERSION = 2.3.0
PTPD2_SITE = http://downloads.sourceforge.net/project/ptpd/ptpd/$(PTPD2_VERSION)
PTPD2_SOURCE = ptpd-$(PTPD2_VERSION).tar.gz
PTPD2_DEPENDENCIES = libpcap
# configure not shipped
PTPD2_AUTORECONF = YES
PTPD2_LICENSE = BSD-2c
PTPD2_LICENSE_FILES = COPYRIGHT

define PTPD2_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/ptpd2/S65ptpd2 \
		$(TARGET_DIR)/etc/init.d/S65ptpd2
endef

$(eval $(autotools-package))
