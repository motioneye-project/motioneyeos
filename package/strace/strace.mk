#############################################################
#
# strace
#
#############################################################

STRACE_VERSION = 4.7
STRACE_SOURCE = strace-$(STRACE_VERSION).tar.xz
STRACE_SITE = http://downloads.sourceforge.net/project/strace/strace/$(STRACE_VERSION)
STRACE_LICENSE = BSD-3c
STRACE_LICENSE_FILES = COPYRIGHT

STRACE_CONF_ENV = ac_cv_header_linux_if_packet_h=yes \
		  ac_cv_header_linux_netlink_h=yes

ifeq ($(BR2_LARGEFILE),y)
# strace gets confused when lfs mode is forced, so don't
STRACE_CONF_ENV += \
	CFLAGS="$(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS))" \
	CPPFLAGS="$(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CPPFLAGS))"
endif

define STRACE_REMOVE_STRACE_GRAPH
	rm -f $(TARGET_DIR)/usr/bin/strace-graph
endef

STRACE_POST_INSTALL_TARGET_HOOKS += STRACE_REMOVE_STRACE_GRAPH

$(eval $(autotools-package))
