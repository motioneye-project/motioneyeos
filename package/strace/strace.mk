#############################################################
#
# strace
#
#############################################################

STRACE_VERSION = 4.5.20
STRACE_SOURCE = strace-$(STRACE_VERSION).tar.bz2
STRACE_SITE = http://downloads.sourceforge.net/project/strace/strace/$(STRACE_VERSION)

STRACE_CONF_ENV = ac_cv_header_linux_if_packet_h=yes \
		  ac_cv_header_linux_netlink_h=yes \
	          $(if $(BR2_LARGEFILE),ac_cv_type_stat64=yes,ac_cv_type_stat64=no)

define STRACE_REMOVE_STRACE_GRAPH
	rm -f $(TARGET_DIR)/usr/bin/strace-graph
endef

STRACE_POST_INSTALL_TARGET_HOOKS += STRACE_REMOVE_STRACE_GRAPH

$(eval $(autotools-package))
