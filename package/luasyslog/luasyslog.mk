################################################################################
#
# luasyslog
#
################################################################################

LUASYSLOG_VERSION = 1.0.0-2
LUASYSLOG_LICENSE = MIT
LUASYSLOG_LICENSE_FILES = $(LUASYSLOG_SUBDIR)/COPYING

$(eval $(luarocks-package))
