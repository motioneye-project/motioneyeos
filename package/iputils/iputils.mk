################################################################################
#
# iputils
#
################################################################################

# The original upstream was forked to the github repository in 2014 to
# pull fixes from other distribution and centralize the changes after
# the upstream seemed to have gone dormant.  The fork contains the
# latest changes including musl support, removing a libsysfs dependency
# and IPv6 updates.
# http://www.spinics.net/lists/netdev/msg279881.html

IPUTILS_VERSION = s20180629
IPUTILS_SITE = $(call github,iputils,iputils,$(IPUTILS_VERSION))
IPUTILS_LICENSE = GPL-2.0+, BSD-3-Clause, BSD-4-Clause
# Only includes a license file for BSD
IPUTILS_LICENSE_FILES = ninfod/COPYING

IPUTILS_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS) USE_SYSFS=no USE_IDN=no\
	CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

ifeq ($(BR2_PACKAGE_LIBCAP),y)
IPUTILS_MAKE_OPTS += USE_CAP=yes
IPUTILS_DEPENDENCIES += libcap
else
IPUTILS_MAKE_OPTS += USE_CAP=no
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
IPUTILS_MAKE_OPTS += USE_GCRYPT=yes
IPUTILS_DEPENDENCIES += libgcrypt
else
IPUTILS_MAKE_OPTS += USE_GCRYPT=no
endif

ifeq ($(BR2_PACKAGE_NETTLE),y)
IPUTILS_MAKE_OPTS += USE_NETTLE=yes
IPUTILS_DEPENDENCIES += nettle
else
IPUTILS_MAKE_OPTS += USE_NETTLE=no
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
IPUTILS_MAKE_OPTS += USE_CRYPTO=yes
IPUTILS_DEPENDENCIES += openssl
else
IPUTILS_MAKE_OPTS += USE_CRYPTO=no
endif

define IPUTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(IPUTILS_MAKE_OPTS)
endef

define IPUTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/arping      $(TARGET_DIR)/sbin/arping
	$(INSTALL) -D -m 755 $(@D)/clockdiff   $(TARGET_DIR)/bin/clockdiff
	$(INSTALL) -D -m 755 $(@D)/ping        $(TARGET_DIR)/bin/ping
	$(INSTALL) -D -m 755 $(@D)/rarpd       $(TARGET_DIR)/sbin/rarpd
	$(INSTALL) -D -m 755 $(@D)/rdisc       $(TARGET_DIR)/sbin/rdisc
	$(INSTALL) -D -m 755 $(@D)/tftpd       $(TARGET_DIR)/usr/sbin/in.tftpd
	$(INSTALL) -D -m 755 $(@D)/tracepath   $(TARGET_DIR)/bin/tracepath
	$(INSTALL) -D -m 755 $(@D)/traceroute6 $(TARGET_DIR)/bin/traceroute6
endef

define IPUTILS_PERMISSIONS
	/bin/ping        f 4755 0 0 - - - - -
	/bin/traceroute6 f 4755 0 0 - - - - -
endef

$(eval $(generic-package))
