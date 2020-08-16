################################################################################
#
# ussp-push
#
################################################################################

USSP_PUSH_VERSION = 0.11
USSP_PUSH_SITE = http://www.xmailserver.org
USSP_PUSH_LICENSE = GPL-2.0+
USSP_PUSH_LICENSE_FILES = COPYING

USSP_PUSH_DEPENDENCIES = bluez5_utils openobex

$(eval $(autotools-package))
