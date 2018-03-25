################################################################################
#
# strace
#
################################################################################

STRACE_VERSION = 4.21
STRACE_SOURCE = strace-$(STRACE_VERSION).tar.xz
STRACE_SITE = https://strace.io/files/$(STRACE_VERSION)
STRACE_LICENSE = BSD-3-Clause
STRACE_LICENSE_FILES = COPYING
STRACE_CONF_OPTS = --enable-mpers=check

define STRACE_REMOVE_STRACE_GRAPH
	rm -f $(TARGET_DIR)/usr/bin/strace-graph
endef

STRACE_POST_INSTALL_TARGET_HOOKS += STRACE_REMOVE_STRACE_GRAPH

$(eval $(autotools-package))
