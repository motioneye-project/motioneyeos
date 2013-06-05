################################################################################
#
# tftpd
#
################################################################################

TFTPD_VERSION  = 5.2
TFTPD_SOURCE   = tftp-hpa-$(TFTPD_VERSION).tar.bz2
TFTPD_SITE     = $(BR2_KERNEL_MIRROR)/software/network/tftp/tftp-hpa
TFTPD_CONF_OPT = --without-tcpwrappers

ifneq ($(BR2_INET_IPV6),y)
TFTPD_CONF_OPT += --without-ipv6
endif

define TFTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/tftpd/tftpd $(TARGET_DIR)/usr/sbin/tftpd
	$(INSTALL) -D package/tftpd/S80tftpd-hpa $(TARGET_DIR)/etc/init.d/
endef

$(eval $(autotools-package))
