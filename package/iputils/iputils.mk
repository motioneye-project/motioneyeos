################################################################################
#
# iputils
#
################################################################################

# The original upstream was forked to the github repository in 2014 to
# pull fixes from other distribution and centralize the changes after
# the upstream seemed to have gone dormant.  The fork contains the
# latest changes including msul support, removing a libsysfs dependency
# and IPv6 updates.
# http://www.spinics.net/lists/netdev/msg279881.html

IPUTILS_VERSION = c8ff6feaf0442f8efd96ccb415770c54f9e84d47
IPUTILS_SITE = $(call github,iputils,iputils,$(IPUTILS_VERSION))
IPUTILS_LICENSE = GPLv2+, BSD-3c, BSD-4c
# Only includes a license file for BSD
IPUTILS_LICENSE_FILES = ninfod/COPYING
IPUTILS_DEPENDENCIES = openssl

# Build after busybox so target ends up with this package's full
# versions of the applications instead of busybox applets.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
IPUTILS_DEPENDENCIES += busybox
endif

IPUTILS_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS) USE_SYSFS=no USE_IDN=no\
	CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

ifeq ($(BR2_PACKAGE_LIBCAP),y)
IPUTILS_MAKE_OPTS += USE_CAP=yes
IPUTILS_DEPENDENCIES += libcap
else
IPUTILS_MAKE_OPTS += USE_CAP=no
endif

define IPUTILS_BUILD_CMDS
	$(MAKE) -C $(@D) $(IPUTILS_MAKE_OPTS)
endef

define IPUTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/arping      $(TARGET_DIR)/sbin/arping
	$(INSTALL) -D -m 755 $(@D)/clockdiff   $(TARGET_DIR)/bin/clockdiff
	$(INSTALL) -D -m 755 $(@D)/ping        $(TARGET_DIR)/bin/ping
	$(INSTALL) -D -m 755 $(@D)/rarpd       $(TARGET_DIR)/sbin/rarpd
	$(INSTALL) -D -m 755 $(@D)/rdisc       $(TARGET_DIR)/sbin/rdisc
	$(INSTALL) -D -m 755 $(@D)/tftpd       $(TARGET_DIR)/usr/sbin/in.tftpd
	$(INSTALL) -D -m 755 $(@D)/tracepath   $(TARGET_DIR)/bin/tracepath
	$(INSTALL) -D -m 755 $(@D)/tracepath6  $(TARGET_DIR)/bin/tracepath6
	$(INSTALL) -D -m 755 $(@D)/traceroute6 $(TARGET_DIR)/bin/traceroute6
endef

$(eval $(generic-package))
