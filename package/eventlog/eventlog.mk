################################################################################
#
# eventlog
#
################################################################################

EVENTLOG_VERSION_MAJOR = 0.2
EVENTLOG_VERSION = $(EVENTLOG_VERSION_MAJOR).12
EVENTLOG_SOURCE = eventlog_$(EVENTLOG_VERSION).tar.gz
EVENTLOG_SITE = https://my.balabit.com/downloads/eventlog/$(EVENTLOG_VERSION_MAJOR)
EVENTLOG_LICENSE = BSD-3-Clause
EVENTLOG_LICENSE_FILES = COPYING
EVENTLOG_INSTALL_STAGING = YES

$(eval $(autotools-package))
