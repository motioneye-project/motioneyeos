################################################################################
#
# eventlog
#
################################################################################

EVENTLOG_VERSION = 0.2.12
EVENTLOG_SOURCE = eventlog_$(EVENTLOG_VERSION).tar.gz
EVENTLOG_SITE = https://my.balabit.com/downloads/eventlog/0.2
EVENTLOG_LICENSE = BSD-3c
EVENTLOG_LICENSE_FILES = COPYING
EVENTLOG_INSTALL_STAGING = YES

$(eval $(autotools-package))
