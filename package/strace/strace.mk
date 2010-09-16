#############################################################
#
# strace
#
#############################################################
STRACE_VERSION:=4.5.20
STRACE_SOURCE:=strace-$(STRACE_VERSION).tar.bz2
STRACE_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/strace
STRACE_AUTORECONF:=NO
STRACE_INSTALL_STAGING:=NO
STRACE_INSTALL_TARGET:=YES

STRACE_CONF_ENV:= ac_cv_header_linux_if_packet_h=yes \
		  ac_cv_header_linux_netlink_h=yes \
	          $(if $(BR2_LARGEFILE),ac_cv_type_stat64=yes,ac_cv_type_stat64=no)

define STRACE_REMOVE_STRACE_GRAPH
	rm -f $(TARGET_DIR)/usr/bin/strace-graph
endef

STRACE_POST_INSTALL_TARGET_HOOKS += STRACE_REMOVE_STRACE_GRAPH

define STRACE_INSTALL_TOOLCHAIN_TARGET_UTILS
	mkdir -p $(STAGING_DIR)/usr/$(REAL_GNU_TARGET_NAME)/target_utils
	install -c $(TARGET_DIR)/usr/bin/strace \
		$(STAGING_DIR)/usr/$(REAL_GNU_TARGET_NAME)/target_utils/strace
endef

ifeq ($(BR2_CROSS_TOOLCHAIN_TARGET_UTILS),y)
STRACE_POST_INSTALL_TARGET_HOOKS += STRACE_INSTALL_TOOLCHAIN_TARGET_UTILS
endif

$(eval $(call AUTOTARGETS,package,strace))
