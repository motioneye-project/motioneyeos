################################################################################
#
# strace
#
################################################################################

STRACE_VERSION = 4.13
STRACE_SOURCE = strace-$(STRACE_VERSION).tar.xz
STRACE_SITE = http://downloads.sourceforge.net/project/strace/strace/$(STRACE_VERSION)
STRACE_LICENSE = BSD-3c
STRACE_LICENSE_FILES = COPYING

define STRACE_REMOVE_STRACE_GRAPH
	rm -f $(TARGET_DIR)/usr/bin/strace-graph
endef

STRACE_POST_INSTALL_TARGET_HOOKS += STRACE_REMOVE_STRACE_GRAPH

$(eval $(autotools-package))
