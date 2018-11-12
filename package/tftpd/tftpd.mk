################################################################################
#
# tftpd
#
################################################################################

TFTPD_VERSION = 5.2
TFTPD_SOURCE = tftp-hpa-$(TFTPD_VERSION).tar.xz
TFTPD_SITE = $(BR2_KERNEL_MIRROR)/software/network/tftp/tftp-hpa
TFTPD_CONF_OPTS = --without-tcpwrappers

define TFTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/tftp/tftp $(TARGET_DIR)/usr/bin/tftp
	$(INSTALL) -D $(@D)/tftpd/tftpd $(TARGET_DIR)/usr/sbin/tftpd
endef

define TFTPD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/tftpd/S80tftpd-hpa $(TARGET_DIR)/etc/init.d/S80tftpd-hpa
endef

$(eval $(autotools-package))
