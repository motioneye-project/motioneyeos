################################################################################
#
# udpcast
#
################################################################################

UDPCAST_VERSION = 20120424
UDPCAST_SOURCE = udpcast-$(UDPCAST_VERSION).tar.gz
UDPCAST_SITE = http://www.udpcast.linux.lu/download
UDPCAST_CONF_ENV = $(if $(BR_LARGEFILE),ac_cv_type_stat64=yes,ac_cv_type_stat64=no)
UDPCAST_DEPENDENCIES = host-m4

define UDPCAST_REMOVE_UDP_SENDER
	rm -f $(TARGET_DIR)/usr/sbin/udp-sender
	rm -f $(TARGET_DIR)/usr/sbin/udp-sender.1
endef

ifneq ($(BR2_PACKAGE_UDPCAST_SENDER),y)
UDPCAST_POST_INSTALL_TARGET_HOOKS += UDPCAST_REMOVE_UDP_SENDER
endif

define UDPCAST_REMOVE_UDP_RECEIVER
	rm -f $(TARGET_DIR)/usr/sbin/udp-receiver
	rm -f $(TARGET_DIR)/usr/sbin/udp-receiver.1
endef

ifneq ($(BR2_PACKAGE_UDPCAST_RECEIVER),y)
UDPCAST_POST_INSTALL_TARGET_HOOKS += UDPCAST_REMOVE_UDP_RECEIVER
endif

$(eval $(autotools-package))
