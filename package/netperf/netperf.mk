################################################################################
#
# netperf
#
################################################################################

NETPERF_VERSION = 2.7.0
NETPERF_SITE = ftp://ftp.netperf.org/netperf
NETPERF_SOURCE = netperf-$(NETPERF_VERSION).tar.bz2
# gcc 5+ defaults to gnu99 which breaks netperf
NETPERF_CONF_ENV = \
	ac_cv_func_setpgrp_void=set \
	CFLAGS="$(TARGET_CFLAGS) -std=gnu89"
NETPERF_CONF_OPTS = --enable-demo=yes
NETPERF_LICENSE = netperf license
NETPERF_LICENSE_FILES = COPYING

define NETPERF_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/src/netperf \
		$(TARGET_DIR)/usr/bin/netperf
	$(INSTALL) -m 0755 $(@D)/src/netserver \
		$(TARGET_DIR)/usr/bin/netserver
endef

$(eval $(autotools-package))
