################################################################################
#
# iputils
#
################################################################################

IPUTILS_VERSION = s20121011
IPUTILS_SITE = http://www.skbuff.net/iputils
IPUTILS_SOURCE = iputils-$(IPUTILS_VERSION).tar.bz2
IPUTILS_LICENSE = GPLv2+ BSD-3c
# Only includes a license file for BSD
IPUTILS_LICENSE_FILES = ninfod/COPYING

# Build after busybox so target ends up with this package's full
# versions of the applications instead of busybox applets.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
IPUTILS_DEPENDENCIES += busybox
endif

# Disabling CAP_SETPCAP (file capabilities)
IPUTILS_MAKE_OPT = $(TARGET_CONFIGURE_OPTS) USE_CAP=no USE_SYSFS=no\
	CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE" \
	arping clockdiff ping rarpd rdisc tftpd tracepath

ifeq ($(BR2_INET_IPV6),y)
# To support md5 for ping6
IPUTILS_DEPENDENCIES += openssl

IPUTILS_MAKE_OPT += ping6 tracepath6 traceroute6

define IPUTILS_IPV6_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/ping6       $(TARGET_DIR)/bin/ping6
	$(INSTALL) -D -m 755 $(@D)/tracepath6  $(TARGET_DIR)/bin/tracepath6
	$(INSTALL) -D -m 755 $(@D)/traceroute6 $(TARGET_DIR)/bin/traceroute6
endef
endif

define IPUTILS_BUILD_CMDS
	$(MAKE) -C $(@D) $(IPUTILS_MAKE_OPT)
endef

define IPUTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/arping      $(TARGET_DIR)/sbin/arping
	$(INSTALL) -D -m 755 $(@D)/clockdiff   $(TARGET_DIR)/bin/clockdiff
	$(INSTALL) -D -m 755 $(@D)/ping        $(TARGET_DIR)/bin/ping
	$(INSTALL) -D -m 755 $(@D)/rarpd       $(TARGET_DIR)/sbin/rarpd
	$(INSTALL) -D -m 755 $(@D)/rdisc       $(TARGET_DIR)/sbin/rdisc
	$(INSTALL) -D -m 755 $(@D)/tftpd       $(TARGET_DIR)/usr/sbin/in.tftpd
	$(INSTALL) -D -m 755 $(@D)/tracepath   $(TARGET_DIR)/bin/tracepath
	$(IPUTILS_IPV6_INSTALL_TARGET_CMDS)
endef

$(eval $(generic-package))
