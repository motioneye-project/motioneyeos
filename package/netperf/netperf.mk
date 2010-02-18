#############################################################
#
# netperf
#
#############################################################

NETPERF_VERSION = 2.4.5
NETPERF_SITE = ftp://ftp.netperf.org/netperf
NETPERF_CONF_ENV = ac_cv_func_setpgrp_void=set

$(eval $(call AUTOTARGETS,package,netperf))

$(NETPERF_TARGET_INSTALL_TARGET):
	$(call MESSAGE,"Installing to target")
	$(INSTALL) -m 0755 $(NETPERF_DIR)/src/netperf \
		$(TARGET_DIR)/usr/bin/netperf
	$(INSTALL) -m 0755 $(NETPERF_DIR)/src/netserver \
		$(TARGET_DIR)/usr/bin/netserver
	touch $@

$(NETPERF_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/bin/netperf
	rm -f $(TARGET_DIR)/usr/bin/netserver
	rm -f $(NETPERF_TARGET_INSTALL_TARGET) $(NETPERF_HOOK_POST_INSTALL)
