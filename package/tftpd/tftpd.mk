#############################################################
#
# tftpd
#
#############################################################
TFTPD_VERSION  = 5.0
TFTPD_SOURCE   = tftp-hpa-$(TFTPD_VERSION).tar.bz2
TFTPD_SITE     = $(BR2_KERNEL_MIRROR)/software/network/tftp/
TFTPD_CONF_OPT = --without-tcpwrappers

define TFTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/tftpd/tftpd $(TARGET_DIR)/usr/sbin/tftpd
	$(INSTALL) -D package/tftpd/S80tftpd-hpa $(TARGET_DIR)/etc/init.d/
endef

$(eval $(call AUTOTARGETS,package,tftpd))
